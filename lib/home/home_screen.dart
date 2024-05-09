import 'package:finalproject/home/bottom_sheet.dart';
import 'package:finalproject/leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'package:finalproject/leaning-modes/quizz-mode/quiz_screen.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:finalproject/screens/profile_screen.dart';
import 'package:finalproject/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/SharedPreferencesHelper.dart';
import '../model/User.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  String userID ="";
  String email = "";

  // void _initSharedPreferences() async {
  //   await sharedPreferencesHelper.init();
  //   setState(() async {
  //     userID = await sharedPreferencesHelper.getUserID() ?? '';
  //     print("id $userID");
  //     email = await sharedPreferencesHelper.getEmail() ?? "";
  //     tProfileSubHeading = email;
  //     print("email $email");
  //   });
  // }

  void _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    String newUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String newEmail = await sharedPreferencesHelper.getEmail() ?? "";
    userID = await sharedPreferencesHelper.getUserID() ?? '';
    email = await sharedPreferencesHelper.getEmail() ?? "";
    tProfileSubHeading = email;
    setState(() {
      userID = newUserID;
      email = newEmail;
      print("id $userID");
      print("email $email");
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    LibraryScreen(),
    BottomSheetScreen(), 
    ProfileScreen(), 
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSharedPreferences();
  }
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   if (index == 1) {
  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext context) {
  //         return BottomSheetWidget();
  //       },
  //     );
  //   }
  // }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Call different functions based on the selected index
      switch (index) {
        case 0:
          _onSearchTapped();
        case 1:
          _onLibraryTapped();
          break;
        case 2:
          _onAddCircleTapped();
          break;
        case 3:
          _onProfileTapped();
          break;
      }
    });
  }
  void _onSearchTapped() {
    print("search tapped");
  }

  void _onLibraryTapped() {
    // Handle Library tab tap
    print('Library tab tapped');
  }

  void _onAddCircleTapped() {
    // Handle Add Circle tab tap
    _selectedIndex = 1;
    _showBottomSheetItems(context, _selectedIndex);
    print('Add Circle tab tapped');
  }

  void _onProfileTapped() {
    // Handle Profile tab tap
    print('Profile tab tapped');
  }
  Widget _bottomSheetItem({required IconData icon, required String text, required Function onTap, Color? backgroundColor, double borderRadius = 16.0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: backgroundColor,
        child: ListTile(
          leading: Icon(icon),
          title: Text(text),
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }

  void _showBottomSheetItems(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bottomSheetItem(
                icon: Icons.topic,
                text: 'Topic',
                onTap: () {
                  Get.toNamed('/create-topic');
                },
                backgroundColor: Color.fromARGB(255, 199, 191, 191)
              ),
              SizedBox(height: 10,),
              _bottomSheetItem(
                icon: Icons.folder,
                text: 'Folder',
                onTap: () {
                  Get.toNamed('/create-folder');
                },
                backgroundColor: Color.fromARGB(255, 199, 191, 191)
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:  Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.folder),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
