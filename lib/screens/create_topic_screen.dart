import 'package:finalproject/Helper/SharedPreferencesHelper.dart';
import 'package:finalproject/model/Topic.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:flutter/material.dart';
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
    setState(() async {
      userID = await sharedPreferencesHelper.getUserID() ?? '';
      print("id $userID");
      email = await sharedPreferencesHelper.getEmail() ?? "";
      print("email $email");
    });
  }
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _addTerm(); // Add an initial term
  }
  Future<void> _fetchTopics() async {
    List<Topic> topics = await Topic().getTopics();
    setState(() {
      _topics = topics;
    });
  }
  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Create a new topic
        // String? errorMessage = await Topic().createTopic("", getDate(), _title, folderId: "folderID");
        String? topicId = await Topic().createTopic(userID, getDate(), _title, active, folderId: "folderID");
        if (topicId != null) {
          // Create words associated with the newly created topic
          print("Topic ID $topicId");
          for (var vocabMap in _vocabularyList) {
            String engWord = vocabMap["english"]!;
            String vietWord = vocabMap["vietnamese"]!;
            Word word =  Word.n(topicId,engWord, vietWord);
            try{
              await word.createWord();
            } catch(e){
              print("Error creating word $engWord: $e");
              Get.back();
            }
          }
          await _fetchTopics();
          Get.off(LibraryScreen());
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
        title: Text('Create Topic'),
      ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text('Add Topic'),
                ),
              ),
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