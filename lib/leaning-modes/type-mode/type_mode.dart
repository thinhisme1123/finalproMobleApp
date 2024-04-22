import 'package:flutter/material.dart';

class TypeMode extends StatefulWidget {
  @override
  _TypeModeState createState() => _TypeModeState();
}

class _TypeModeState extends State<TypeMode> {
  final List<Map<String, String>> vocabularyList = [
    {'english': 'hello', 'vietnamese': 'xin chào'},
    {'english': 'goodbye', 'vietnamese': 'tạm biệt'},
    {'english': 'thank you', 'vietnamese': 'cảm ơn'},
    // Add more vocabulary items here
  ];

  int currentIndex = 0;
  TextEditingController _textController = TextEditingController();

  void _checkAnswer(String input) {
    if (input.toLowerCase() ==
        vocabularyList[currentIndex]['english']?.toLowerCase()) {
      _showDialog('Correct!');
      _nextWord();
    } else {
      _showDialog(
          'Incorrect. The correct answer is: ${vocabularyList[currentIndex]['english']}');
    }
  }

  void _nextWord() {
    setState(() {
      currentIndex = (currentIndex + 1) % vocabularyList.length;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                vocabularyList[currentIndex]['vietnamese']!,
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
                  _checkAnswer(_textController.text);
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
