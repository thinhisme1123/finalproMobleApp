import 'package:finalproject/screens/create_folder_screen.dart';
import 'package:finalproject/leaning-modes/quizz-mode/quiz_screen.dart';
import 'package:finalproject/screens/create_topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/screens/welcome_screen.dart';
import 'package:finalproject/theme/theme.dart';
import 'package:get/get.dart';
import 'package:finalproject/screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/SharedPreferencesHelper.dart';
import 'firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalproject/utils/Toast.dart' as toast;

import 'home/home_modes_screen.dart';
import 'home/home_screen.dart';
import 'leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'screens/list_topic_to_folder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  bool _isLoggedIn = false;
  bool _isLoading = true;

  

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    bool? isLoggedIn = await sharedPreferencesHelper.getLoginState();
    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        _isLoggedIn = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Thêm MaterialApp widget
      debugShowCheckedModeBanner: false,
      title: 'Learning Vocabulary Application',
      theme: lightMode,
      home: Directionality( 
        textDirection: TextDirection.ltr, 
        child: Builder(
          builder: (context) {
            toast.Toast.initializeToast(context);
            if (_isLoading) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Learning Vocabulary Application',
                theme: lightMode,
                // initialRoute: _isLoggedIn ? "/home-screen" :"/welcome",
                initialRoute: _isLoggedIn ? "/home-screen" :"/welcome",
                getPages: [
                  // GetPage(name: '/flashcard', page: () => FlashCardScreen()),
                  // GetPage(name: '/quizz', page: () => QuizScreen()),
                  GetPage(name: '/welcome', page: () => const WelcomeScreen()),
                  GetPage(name: '/profile', page: () => const ProfileScreen()),
                  GetPage(name: '/home-screen', page: () => HomeScreen()),
                  // GetPage(name: '/home-mode-screen', page: () => HomeScreenModes()),
                  GetPage(name: '/create-topic', page: () => CreateTopic()),
                  GetPage(name: '/create-folder', page: () => CreateFolderScreen()),
                ],
                initialBinding: BindingsBuilder(() {}),
              );
            }
          },
        ),
      ),
    );
  }
}
