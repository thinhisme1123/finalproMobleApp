import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Folder {
  String title = '';
  String description = '';

  Folder();

  Folder.n(this.title, this.description);

 

  Future<String?> createFolder(String title, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection("Folder")
          .add({"Title": title, "Desc": description});
      print("Create Folder Sucessfully");
      return null;
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
          String title = data['Title'] ?? '';
          String description = data['Desc'] ?? '';

          Folder folder = Folder.n(title, description);
          folderList.add(folder);
        }
      }
      return folderList;
    } catch (e) {
      print('Error getting folders: $e');
      return [];
    }
  }

  Future<void> updateFolder(String folderId, String newTitle, String newDescription) async {
    try {
      await FirebaseFirestore.instance.collection("folders").doc(folderId).update({
        "title": newTitle,
        "description": newDescription,
      });

      print("Folder updated successfully");
    } catch (e) {
      print("Error updating folder: $e");
    }
  }

  Future<void> deleteFolder(String folderTitle) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Folder')
          .where('Title', isEqualTo: folderTitle)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Folder $folderTitle deleted successfully');
    } catch (e) {
      print('Error deleting folder: $e');
    }
  }
}
