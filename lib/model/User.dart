import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalproject/utils/Toast.dart' as toast;

class User {

  String email = "";
  String dob = "";

  User();

  User.n(this.email, this.dob);

  Future<String?> createUserDetail(String email, String dob) async {
    try {
      await FirebaseFirestore.instance.collection("User").add({
        "Email": email,
        "DOB": dob
      });
      print("Sucessfully");
      return null;
    } catch (e) {
      print("Error in creating user details: $e");
      return 'Failed to add user details: $e';
    }
  }
  Future<String> getID(final UserCredential userCredential) async {
    String userId = userCredential.user!.uid;
    return userId;
  }
}
