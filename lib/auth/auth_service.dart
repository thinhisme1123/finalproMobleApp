import 'package:finalproject/utils/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSevice {
  final _auth = FirebaseAuth.instance;

  // Future<User?> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     final cred = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return cred.user;
  //   } catch (e) {
  //     print("message ${e.toString()}");
  //     print("Can not create user!");
  //   }
  //   return null;
  // }
  Future<String?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; 
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      }
      return e.message;
    } catch (e) {
      print('Error: $e');
      return 'An unknown error occurred.';
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print("login error");
    }
    return null;
  }
  // Future<String?> loginUserWithEmailAndPassword(String email, String password) async {
  //   try {
  //     final cred = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return null; // No error occurred
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       return 'No user found for that email.';
  //     } else if (e.code == 'wrong-password') {
  //       return 'Wrong password provided for that user.';
  //     }
  //     // Handle other Firebase Auth exceptions here
  //     return e.message;
  //   } catch (e) {
  //     print('Error: $e');
  //     return 'An unknown error occurred.';
  //   }
  // }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("signout error");
    }
  }

  Future sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
