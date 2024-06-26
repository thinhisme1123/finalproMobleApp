import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalproject/utils/Toast.dart' as toast;
import 'package:shared_preferences/shared_preferences.dart';

class User {

  String email = "";
  String dob = "";
  String id ="";
  String avatar = "";

  User();

  User.n(this.email, this.dob, this.id);

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
  Future<String?> getUserIdByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection("User")
          .where("Email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No user found with email $email");
        return null;
      }

      String userId = querySnapshot.docs.first.id;
      print("User ID for email $email: $userId");
      return userId;
    } catch (e) {
      print("Error getting user ID: $e");
      return null;
    }
  }
  Future<String?> getEmailByID(String userID) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('User').doc(userID).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String email = data['Email'] ?? '';
          return email;
        }
      }
      return null;
    } catch (e) {
      print('Error getting email by ID: $e');
      return null;
    }
  }

  // Future<String?> getDBOByEmail(String email) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
  //         .collection("User")
  //         .where("Email", isEqualTo: email)
  //         .get();
  //
  //     if (querySnapshot.docs.isEmpty) {
  //       print("No user found with email $email");
  //       return null;
  //     }
  //
  //     String userEmail = querySnapshot.docs.first.get("DOB");
  //     print("DOB for user with email $email: $userEmail");
  //     return userEmail;
  //   } catch (e) {
  //     print("Error getting DOB: $e");
  //     return null;
  //   }
  // }
  Future<String?> getAvatarByID(String userID) async {
    try {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('User').doc(userID).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
        docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String avatarImg = data['Avatar'] ?? '';
          return avatarImg;
        }
      }
      return "https://firebasestorage.googleapis.com/v0/b/finalmobilecrossplatform.appspot.com/o/images%2Fprofile.jpg?alt=media&token=4106415a-c61f-4940-a0bc-9a19d18f5259";
    } catch (e) {
      print('Error getting avatar by ID: $e');
      return "https://firebasestorage.googleapis.com/v0/b/finalmobilecrossplatform.appspot.com/o/images%2Fprofile.jpg?alt=media&token=4106415a-c61f-4940-a0bc-9a19d18f5259";
    }
  }
  // Future<String?> getAvatarByEmail(String email) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await FirebaseFirestore.instance
  //             .collection("User")
  //             .where("Email", isEqualTo: email)
  //             .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       print("No user found with email $email");
  //       return null;
  //     }

  //     String userEmail = querySnapshot.docs.first.get("Avatar");
  //     print("Avatar for user with email $email: $userEmail");
  //     return userEmail;
  //   } catch (e) {
  //     print("Error getting Avatar: $e");
  //     return null;
  //   }
  // }
  Future<void> changeUserData(String userID, String avatar) async {
    if (userID.isEmpty || avatar.isEmpty) {
      throw Exception("Email and Avatar must not be empty");
    }
    try {
      await FirebaseFirestore.instance.collection("User").doc(userID).update({
        'Avatar': avatar,
      });
    } catch (e) {
      print("Error updating user data: $e");
      throw Exception("Failed to update user data");
    }
  }

}
