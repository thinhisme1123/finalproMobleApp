import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finalproject/Helper/SharedPreferencesHelper.dart';
import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Topic.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../model/Word.dart';

class CreateTopic extends StatefulWidget {
  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  bool active = true;
  late String userID;
  late String email;
  List<Topic> _topics= [];

  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  List<Map<String, String>> _vocabularyList = [];
  List<TextEditingController> _englishControllers = [];
  List<TextEditingController> _vietnameseControllers = [];

  TextEditingController _titleController = TextEditingController();

  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }

  void _initSharedPreferences() async {
    String id = await sharedPreferencesHelper.getUserID() ?? '';
    String userEmail = await sharedPreferencesHelper.getEmail() ?? '';

    setState(() {
      userID = id;
      email = userEmail;
      print("id $userID");
      print("email $email");
    });
  }

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _addTerm(); // Add an initial term
  }
  // Future<void> _fetchTopics() async {
  //   List<Topic> topics = await Topic().getTopics();
  //   setState(() {
  //     _topics = topics;
  //   });
  // }
  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Create a new topic
        String? topicId = await Topic().createTopic(userID, getDate(), _title, active);
        if (topicId != null) {
          //update number of flashcard
          await Topic().updateNumber(_vocabularyList.length, topicId);
          // Create words associated with the newly created topic
          print("Topic ID $topicId");
          for (var vocabMap in _vocabularyList) {
            String engWord = vocabMap["english"]!;
            String vietWord = vocabMap["vietnamese"]!;
            // Word word =  Word.n(topicId,engWord, vietWord);
            try{
              await Word().createWord(topicId, engWord, vietWord);
            } catch(e){
              print("Error creating word $engWord: $e");
              Get.back();
            }
          }
          Fluttertoast.showToast(
              msg: "Topic added successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );          
          
          Get.off(HomeScreen(indexLibrary: 0,));
        }
      } catch (e) {
        print("Error creating topic: $e");
        Get.back();
      }
    }
  }

  void _addTerm() {
    setState(() {
      _vocabularyList.add({"english": "", "vietnamese": ""});
      _englishControllers.add(TextEditingController());
      _vietnameseControllers.add(TextEditingController());
    });
  }

  void _removeTerm(int index) {
    if (_vocabularyList.length > 1) {
      setState(() {
        _vocabularyList.removeAt(index);
        _englishControllers.removeAt(index);
        _vietnameseControllers.removeAt(index);
      });
    }
  }

  Future<void> _importFromCSV(List<int> fileBytes) async {
    // Decode file bytes to UTF-8 string
    String csvData = utf8.decode(fileBytes);

    // Parse CSV data
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

    setState(() {
      // Clear existing data
      _vocabularyList.clear();
      _englishControllers.clear();
      _vietnameseControllers.clear();

      // Skip the header row
      for (int i = 1; i < rows.length; i++) {
        List<dynamic> row = rows[i];
        String englishWord = row[0].toString(); // English word
        String vietnameseWord = row[1].toString(); // Vietnamese word

        // Add the vocabulary to your list
        _vocabularyList.add({"english": englishWord, "vietnamese": vietnameseWord});
        _englishControllers.add(TextEditingController(text: englishWord));
        _vietnameseControllers.add(TextEditingController(text: vietnameseWord));
      }
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _englishControllers) {
      controller.dispose();
    }
    for (var controller in _vietnameseControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 89, 255, 1),
        title: Text('Create Topic'),
          actions: [
            IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                );

                if (result != null) {
                  PlatformFile file = result.files.single;
                  if (file.bytes != null) {
                    List<int> fileBytes = file.bytes!;
                    _importFromCSV(fileBytes);
                  } else {
                    print('No file data received');
                  }
                } else {
                  print('No file selected');
                }
              },
              icon: Icon(Icons.upload_file),
            ),
            TextButton(
              onPressed: _handleSave,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            )
          ]      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Topic Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title for your topic.';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _vocabularyList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(UniqueKey().toString()),
                    onDismissed: (direction) => _removeTerm(index),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _englishControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'English Word',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an English word.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _vocabularyList[index]["english"] = value!,
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: _vietnameseControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Vietnamese Meaning',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the Vietnamese meaning.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _vocabularyList[index]["vietnamese"] = value!,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTerm,
        child: Icon(Icons.add),
      ),
    );
  }
}