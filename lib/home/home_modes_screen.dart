import 'package:finalproject/leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'package:finalproject/leaning-modes/quizz-mode/quiz_screen.dart';
import 'package:finalproject/leaning-modes/type-mode/type_mode.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreenModes extends StatefulWidget {
  final String title;
  final String userID ;
  final String date;
  final String? folderId;
  final bool active;
  final String topicID;

  const HomeScreenModes({Key? key, required this.title, required this.date, required this.topicID, required this.active, required this.userID, required this.folderId})
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
      QuizScreen(topicID: widget.topicID),
      TypeMode(),
    ];
  }
  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Modes'),
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
