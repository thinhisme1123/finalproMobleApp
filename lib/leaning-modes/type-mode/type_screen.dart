import 'package:finalproject/leaning-modes/type-mode/type_mode.dart';
import 'package:flutter/material.dart';

import '../../model/Word.dart';

class TypeScreen extends StatefulWidget {
  final String topicID;
  const TypeScreen({Key? key, required this.topicID}): super(key: key);

  @override
  _TypeScreenState createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  late List<TypeMode> _typeList = [];

  int currentIndex = 0;
  TextEditingController _textController = TextEditingController();

  bool _isLoading = true;

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
    // TODO: implement initState
    super.initState();
    _loadWords();
  }
  void _nextWord() {
    setState(() {
      currentIndex = (currentIndex + 1) % _typeList.length;
      _textController.clear();
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
            ? CircularProgressIndicator():
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _typeList[currentIndex].vietWord!,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type the English meaning',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // _checkAnswer(_textController.text);
                  if (_typeList[currentIndex].checkAnswer(_textController.text)) {
                    _showDialog('Correct!');
                    _nextWord();
                  } else {
                    _showDialog('Incorrect. The correct answer is: ${_typeList[currentIndex].engWord}');
                    _nextWord();
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
