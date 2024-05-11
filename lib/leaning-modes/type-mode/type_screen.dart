import 'package:finalproject/Helper/countdown_timer.dart';
import 'package:finalproject/leaning-modes/type-mode/type_mode.dart';
import 'package:finalproject/screens/achievment_topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/Word.dart';

class TypeScreen extends StatefulWidget {
  final String topicID;
  const TypeScreen({Key? key, required this.topicID}) : super(key: key);

  @override
  _TypeScreenState createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  late List<TypeMode> _typeList = [];

  int currentIndex = 0;
  TextEditingController _textController = TextEditingController();
  int correctAnswer = 0;

  bool _isLoading = true;

  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }

  Future<void> _loadWords() async {
    List<Word> words = await Word().getWordsByTopicID(widget.topicID);
    _typeList = words.map((word) {
      return TypeMode(
        engWord: word.engWord,
        vietWord: word.vietWord,
      );
    }).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement
    super.initState();
    _loadWords();
  }

  bool isLastQuestion = false;

  void _nextWord() {
    setState(() {
      currentIndex = (currentIndex + 1) % _typeList.length;
      if (currentIndex == _typeList.length - 1) {
        isLastQuestion = true;
      }
      _textController.clear();
    });

    if (currentIndex == 0) {
      _showFinalDialog();
    }
  }

  Future<void> _showDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isCorrect = message == 'Correct!';
        return AlertDialog(
          backgroundColor:
              isCorrect ? Colors.green.shade100 : Colors.red.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            isCorrect ? 'Correct!' : 'Incorrect',
            style: TextStyle(
              color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            isCorrect
                ? 'Great job!'
                : 'The correct answer is: ${_typeList[currentIndex].engWord}',
            style: TextStyle(
              color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isCorrect) {
                  correctAnswer++;
                }
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color:
                      isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFinalDialog() {
    double score = correctAnswer / _typeList.length * 100;
    String message;
    if (score >= 60) {
      message = "Congratulations! You scored $score%. Keep up the good work!";
    } else {
      message = "Your score is $score%. Don't worry, practice makes perfect!";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              score >= 60 ? Colors.green.shade100 : Colors.red.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            score >= 60 ? 'Well Done!' : 'Try Again',
            style: TextStyle(
              color: score >= 60 ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: score >= 60 ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
          actions: <Widget>[
            if (score < 60)
              TextButton(
                onPressed: () {
                  // Reset the game state and start from the beginning
                  setState(() {
                    currentIndex = 0;
                    correctAnswer = 0;
                    isLastQuestion = false;
                  });
                  _textController.clear();
                  print("restart");
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Restart',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(AchievementTopicScreen());
              },
              child: Text(
                'View Achievement',
                style: TextStyle(
                  color:
                      score >= 60 ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(81, 197, 245, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Question ${currentIndex + 1}/${_typeList.length}', // Display the question number and total questions
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w500,
          ), // Adjust the font size as needed
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Add 10 pixels of padding on the left
            child: Text(
              'Correct Answer:${correctAnswer}/${_typeList.length}',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Playfair Display',
              ),
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(81, 197, 245, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CountUpTimer(color: 0xFF000000),
                    Text(
                      _typeList[currentIndex].vietWord!,
                      style: TextStyle(fontSize: 24,fontFamily: 'Playfair Display',),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type the English meaning',
                      ),
                    ),
                    SizedBox(height: 20),
                    isLastQuestion
                        ? ElevatedButton(
                            onPressed: () {
                              if (_typeList[currentIndex]
                                  .checkAnswer(_textController.text)) {
                                correctAnswer++;
                                _showFinalDialog();
                                //show final dialog if success
                              } else {
                                //show final dialog if fail
                                _showFinalDialog();
                              }
                              print('Sutmit type');
                            },
                            child: Text('Submit'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_typeList[currentIndex]
                                  .checkAnswer(_textController.text)) {
                                _showDialog('Correct!').then((_) {
                                  _nextWord();
                                });
                              } else {
                                _showDialog(
                                        'Incorrect. The correct answer is: ${_typeList[currentIndex].engWord}')
                                    .then((_) {
                                  _nextWord();
                                });
                              }
                            },
                            child: Text('Check Answer'),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
