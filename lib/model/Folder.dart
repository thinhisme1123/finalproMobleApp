import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Folder {
  String title = '';
  String description = '';
  String folderId ="";
  String userId ="";
  Folder();

  Folder.n(this.title, this.description, this.userId);

 

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
          String id = document.id;
          String title = data['Title'] ?? '';
          String description = data['Desc'] ?? '';

          Folder folder = Folder.n(title, description, id);
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

          Folder folder = Folder.n(title, description, folderId);
          return folder;
        }
      }
      return null; // Trả về null nếu không tìm thấy thư mục với ID tương ứng
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
