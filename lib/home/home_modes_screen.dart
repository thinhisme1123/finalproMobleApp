import 'dart:async';

import 'package:finalproject/Helper/countdown_timer.dart';
import 'package:finalproject/Helper/learning_mode_data.dart';
import 'package:finalproject/leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'package:finalproject/leaning-modes/quizz-mode/quiz_screen.dart';
import 'package:finalproject/leaning-modes/type-mode/type_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Helper/SharedPreferencesHelper.dart';
import '../model/History.dart';
import '../model/Quizz_Achievement.dart';

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
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  String userID ="";
  String email = "";
  bool isloading = false;
  void initState() {
    super.initState();
    _widgetOptions = [
      FlashCardScreen(topicID: widget.topicID),
      QuizScreen(topicID: widget.topicID, userID: widget.userID),
      TypeScreen(topicID: widget.topicID),
    ];
    _initSharedPreferences().then((_) {
      storeHistory(userID, getDate(), getTime(), widget.topicID).then((_){
        Quizz_Achievement().updateMostTime(userID, widget.topicID);
        isloading = true;
      });
    });
  }
  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }
  String getTime(){
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }
  Future<void> storeHistory(String userID, String date, String time, String topicID) async{
    try {
      if (await History().checkHistoryExists(userID, topicID)){
        String? historyId = await History().updateHistoryDateTimeAndCount(userID,topicID, date, time);
        if (historyId != null) {
          // print("History update successfully with ID: $historyId");
        } else {
          // print("Error update history for topic");
        }
      }
      else{
        String? historyId = await History().createHistory(userID, date, time,topicID);
        if (historyId != null) {
          // print("History created successfully with ID: $historyId");
        } else {
          // print("Error creating history for topic");
        }
      }
    } catch (e) {
      print('Error processing topics: $e');
    }
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _showDialog(index);
    });
  }
  Future<void> _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    String newUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String newEmail = await sharedPreferencesHelper.getEmail() ?? "";
    userID = await sharedPreferencesHelper.getUserID() ?? '';
    email = await sharedPreferencesHelper.getEmail() ?? "";
    setState(() {
      userID = newUserID;
      email = newEmail;
      print("id $userID");
      print("email $email");
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
    return isloading
        ? Center(child: CircularProgressIndicator())
        :Scaffold(
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
