import 'package:finalproject/Helper/SharedPreferencesHelper.dart';
import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Topic.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/Word.dart';

class EditTopicScreen extends StatefulWidget {
  final String topicId;
  final String title;

  const EditTopicScreen({Key? key,required this.topicId, required this.title,})
      : super(key: key);

  @override
  _EditTopicScreenState createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  bool active = true;
  late String userID;
  late String email;
  List<Topic> _topics = [];
  List<Word> words = [];

  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper();

  List<Map<String, String>> _vocabularyList = [];
  List<TextEditingController> _englishControllers = [];
  List<TextEditingController> _vietnameseControllers = [];

  TextEditingController _titleController = TextEditingController();

  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }

  Future<void> _loadWords() async {
    List<Word> words = await Word().getWordsByTopicID(widget.topicId);
    
    setState(() {
      words = words;
    });
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
    _titleController.text = widget.title;
    _loadWords();
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
        String? topicId = await Topic().createTopic(
            userID, getDate(), _title, active,
            folderId: "folderID");
        if (topicId != null) {
          // Create words associated with the newly created topic
          print("Topic ID $topicId");
          for (var vocabMap in _vocabularyList) {
            String engWord = vocabMap["english"]!;
            String vietWord = vocabMap["vietnamese"]!;
            // Word word =  Word.n(topicId,engWord, vietWord);
            try {
              await Word().createWord(topicId, engWord, vietWord);
            } catch (e) {
              print("Error creating word $engWord: $e");
              Get.back();
            }
          }
          await _fetchTopics();
          Get.off(HomeScreen());
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
        backgroundColor: Color.fromRGBO(74, 89, 255,1),
        title: Text('Create Topic'),
        actions: [IconButton(onPressed: () {
          print('exelfile');
        }, icon: Icon(Icons.upload_file))],
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
                itemCount: words.length,
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
                                  onSaved: (value) => _vocabularyList[index]
                                      ["english"] = value!,
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
                                  onSaved: (value) => _vocabularyList[index]
                                      ["vietnamese"] = value!,
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
