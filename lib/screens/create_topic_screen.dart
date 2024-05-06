import 'package:finalproject/model/Topic.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTopic extends StatefulWidget {
  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  List<Map<String, String>> _vocabularyList = [];
  List<TextEditingController> _englishControllers = [];
  List<TextEditingController> _vietnameseControllers = [];

  TextEditingController _titleController = TextEditingController();

  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }

  @override
  void initState() {
    super.initState();
    _addTerm(); // Add an initial term
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Create a new topic
        String? errorMessage = await Topic().createTopic(_title, getDate());

        if (errorMessage == null) {
          // Fetch the newly created topic from Firestore
          List<Topic> topics = await Topic().getTopics();
          Topic newTopic = topics.last; // Assuming the last topic is the one just created

          //title và danh sách các từ vựng
          print("Topic created: ${newTopic.title}");
          // //in từ tiếng anh
          // print("Engling words:");
          // for (var vocabMap in _vocabularyList) {
          //   String? englishWord = vocabMap["english"];
          //   print(englishWord);
          // }
          // //in từ tiếng việt
          // print("Vietname words:");
          // for (var vocabMap in _vocabularyList) {
          //   String? englishWord = vocabMap["vietnamese"];
          //   print(englishWord);
          // }


          //chuyển qua home screen mode và đổ dữ liệu vào để bắt đầu học topic này
          // Navigate to the next screen or perform additional actions
          // For example:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => TopicDetailScreen(topic: newTopic),
          //   ),
          // );
          Get.back();
        } else {
          print(errorMessage);
          // Handle the error here, e.g., show a snackbar or dialog
        }
      } catch (e) {
        print("Error creating topic: $e");
        Get.back();
        // Handle the error here, e.g., show a snackbar or dialog
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