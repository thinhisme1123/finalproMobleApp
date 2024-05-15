import 'package:finalproject/Helper/SharedPreferencesHelper.dart';
import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Topic.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/Word.dart';

class EditTopicScreen extends StatefulWidget {
  final String topicId;
  final String title;
  final bool active;
  final int number;
  const EditTopicScreen({Key? key,required this.topicId, required this.title, required this.active, required this.number,})
      : super(key: key);

  @override
  _EditTopicScreenState createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  late bool active;
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
    List<Word> loadedWords = await Word().getWordsByTopicID(widget.topicId);
    setState(() {
      words = loadedWords;
      _englishControllers.clear();
      _vietnameseControllers.clear();
      _vocabularyList.clear();
      for (var word in words) {
        _englishControllers.add(TextEditingController(text: word.engWord));
        _vietnameseControllers
            .add(TextEditingController(text: word.vietWord));
        _vocabularyList.add({
          "english": word.engWord,
          "vietnamese": word.vietWord,
          "wordID": word.wordID
        });
      }
      print(words.length);
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
    active = widget.active;
    _titleController.text = widget.title;
    _loadWords();
  }


  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Cập nhật thông tin chủ đề
        await Topic().updateTopicAndWord(widget.topicId, _title, _vocabularyList.length, active, _vocabularyList);

        // Duyệt qua từng từ trong danh sách từ
        for (var vocabMap in _vocabularyList) {
          if (vocabMap["deleted"] != "true") {
            // Kiểm tra xem từ có bị đánh dấu là đã xoá không
            // Nếu từ có ID, đó là từ đã tồn tại và bạn cần cập nhật nó
            if (vocabMap.containsKey("wordID")) {
              // Lấy ID của từ
              String wordId = vocabMap["wordID"] ?? "";
              // Lấy từ tiếng Anh và tiếng Việt từ danh sách từ
              String engWord = vocabMap["english"] ?? "";
              String vietWord = vocabMap["vietnamese"] ?? "";
              // Cập nhật từ trong cơ sở dữ liệu
              await Word().updateWord(wordId, engWord, vietWord);
            } else {
              // Nếu từ không có ID, đó là từ mới và bạn cần tạo nó
              String engWord = vocabMap["english"] ?? "";
              String vietWord = vocabMap["vietnamese"] ?? "";
              // Tạo từ mới trong cơ sở dữ liệu và lấy ID của nó
              String? wordId = await Word().createWord(widget.topicId, engWord, vietWord);
              if (wordId == null) {
                // Xử lý lỗi nếu không thể tạo từ mới
                print("Error creating word: $engWord");
              }
            }
          } else {
            String? wordId = vocabMap["wordID"];
            if (wordId != null) {
              await Word().deleteWordById(wordId);
            }
          }
        }
        // Sau khi lưu thành công, điều hướng đến màn hình chính
        Get.off(HomeScreen());
      } catch (e) {
        // Xử lý lỗi nếu không thể cập nhật chủ đề hoặc từ
        print("Error updating topic or words: $e");
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
        title: Text('Update Topic', style: TextStyle(
          color: Colors.white
        ),),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                active = !active;
              });
            },
            icon: Icon(active ? Icons.lock_open : Icons.lock),
          ),
        ],
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
                  child: Text('Save Topic'),
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
