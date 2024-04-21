import 'package:finalproject/screens/update.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/screens/welcome_screen.dart';
import 'package:finalproject/theme/theme.dart';
import 'package:get/get.dart';
import 'package:finalproject/screens/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashCard Learning',
      theme: lightMode, // Assuming you have defined the `lightMode` theme
      initialRoute: '/welcome', // Set the initial route
      getPages: [
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
      initialBinding: BindingsBuilder(() {
        
      }),
    );
  }
}
