import 'package:finalproject/home/home_modes_screen.dart';
import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/leaning-modes/flashcard-mode/flashcard_screen.dart';
import 'package:finalproject/screens/update.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/screens/welcome_screen.dart';
import 'package:finalproject/theme/theme.dart';
import 'package:get/get.dart';
import 'package:finalproject/screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalproject/utils/Toast.dart' as toast;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web, 
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        toast.Toast.initializeToast(context);
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Learning Vocabulary Application',
          theme: lightMode,
          initialRoute: '/welcome',
          getPages: [
            GetPage(name: '/welcome', page: () => const WelcomeScreen()),
            GetPage(name: '/profile', page: () => const ProfileScreen()),
            GetPage(name: '/home-screen', page: () => HomeScreen()),
            GetPage(name: '/home-mode-screen', page: () => HomeScreenModes()),
          ],
          initialBinding: BindingsBuilder(() {}),
        );
      },
    );
  }
}
