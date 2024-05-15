import 'dart:async';

import 'package:finalproject/Helper/countdown_timer.dart';
import 'package:finalproject/Helper/learning_mode_data.dart';
import 'package:finalproject/leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'package:finalproject/leaning-modes/quizz-mode/quiz_screen.dart';
import 'package:finalproject/leaning-modes/type-mode/type_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeScreenModes extends StatefulWidget {
  final String title;
  final String userID;
  final String date;
  final String? folderId;
  final bool active;
  final String topicID;

  const HomeScreenModes(
      {Key? key,
      required this.title,
      required this.date,
      required this.topicID,
      required this.active,
      required this.userID,
      required this.folderId})
      : super(key: key);
  @override
  _HomeScreenModesState createState() => _HomeScreenModesState();
}

class _HomeScreenModesState extends State<HomeScreenModes> {
  int _selectedIndex = 0;
  late String topicID;
  static List<Widget> _widgetOptions = <Widget>[];

  void initState() {
    super.initState();
    _widgetOptions = [
      FlashCardScreen(topicID: widget.topicID),
      QuizScreen(topicID: widget.topicID, userID: widget.userID),
      TypeScreen(topicID: widget.topicID),
    ];
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _showDialog(index);
    });
  }

  Future<void> _showDialog(int index) async {
    String message;
    if (index == 0) {
      message = 'Are you sure you want to move to FlashCard learning?';
    } else if (index == 1) {
      message = 'Are you sure you want to move to Quizz learning?';
    } else if (index == 2) {
      message = 'Are you sure you want to move to Type learning?';
    } else if (index == 3) {
      message = 'Are you sure you want to exit learning?';
    } else {
      // Handle invalid index, or add more conditions as needed
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Exit this screen',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Navigate to another screen
                setState(() {
                  if(index != 3) {
                    _selectedIndex = index;
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Modes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _showDialog(3).then((value) => Get.back());
          },
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'FlashCard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Type',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
