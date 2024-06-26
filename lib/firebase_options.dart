// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios; 
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4tU5UrvShpTJx4NWItzrm2GaMzmYrRJ8',
    appId: '1:700180130860:web:c2901779bf1aaf37b0f589',
    messagingSenderId: '700180130860',
    projectId: 'finalmobilecrossplatform',
    authDomain: 'finalmobilecrossplatform.firebaseapp.com',
    storageBucket: 'finalmobilecrossplatform.appspot.com',
    measurementId: 'G-3F9SJVPBNG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuf5jRtDOIIVwReVbGnoKUEycS1eyKMjo',
    appId: '1:700180130860:android:bcba00ad279016f6b0f589',
    messagingSenderId: '700180130860',
    projectId: 'finalmobilecrossplatform',
    storageBucket: 'finalmobilecrossplatform.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDdTRSOnZCnHd1vBnbnB-LXJz4pFfQLWuw',
    appId: '1:700180130860:ios:da0fa71ca1520d5ab0f589',
    messagingSenderId: '700180130860',
    projectId: 'finalmobilecrossplatform',
    storageBucket: 'finalmobilecrossplatform.appspot.com',
    iosBundleId: 'com.example.finalprpject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDdTRSOnZCnHd1vBnbnB-LXJz4pFfQLWuw',
    appId: '1:700180130860:ios:f1f59432fa53311bb0f589',
    messagingSenderId: '700180130860',
    projectId: 'finalmobilecrossplatform',
    storageBucket: 'finalmobilecrossplatform.appspot.com',
    iosBundleId: 'com.example.finalprpject.RunnerTests',
  );
}
