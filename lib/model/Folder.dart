import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Folder {
  String title = '';
  String description = '';
  String folderId ="";
  String userId ="";
  Folder();

  Folder.n(this.title, this.description, this.userId, this.folderId);



  Future<String?> createFolder(String title, String description, String userId) async {
    try {
      Map<String, dynamic> data = {
        "Title": title,
        "Desc": description,
        "UserID": userId,
      };
      DocumentReference docRef = await FirebaseFirestore.instance.collection("Folder").add(data);
      print("Folder created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error in creating user details: $e");
      return 'Failed to add user details: $e';
    }
  }

  Future<List<Folder>> getFolders() async {
    List<Folder> folderList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Folder').get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String userId = data["userID"] ?? "";
          String folderId = document.id;
          String title = data['Title'] ?? '';
          String description = data['Desc'] ?? '';

          Folder folder = Folder.n(title, description, userId, folderId);
          folderList.add(folder);
        }
      }
      return folderList;
    } catch (e) {
      print('Error getting folders: $e');
      return [];
    }
  }
  Future<Folder?> getFolderByID(String folderId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Folder').doc(folderId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String title = data['Title'] ?? '';
          String description = data['Desc'] ?? '';
          String userID = data["userID"] ?? "";
          Folder folder = Folder.n(title, description, userID , folderId);
          return folder;
        }
      }
      return null;
    } catch (e) {
      print('Error getting folder by ID: $e');
      return null;
    }
  }

  Future<void> updateFolder(String folderId, String newTitle, String newDescription) async {
    try {
      await FirebaseFirestore.instance.collection("Folder").doc(folderId).update({
        "Title": newTitle,
        "Desc": newDescription,
      });

      print("Folder updated successfully");
    } catch (e) {
      print("Error updating folder: $e");
    }
  }
  Future<void> deleteFolderByID(String folderID) async {
    try {
      await  FirebaseFirestore.instance.collection("Folder").doc(folderID).delete();
      print('Folder $folderID deleted successfully');
    } catch (e) {
      print('Error deleting folder: $e');
    }
  }
}
