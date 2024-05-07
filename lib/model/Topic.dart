import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String title = '';
  String userID = '';
  String date = '';
  String? folderId; // Optional folderId to associate the topic with a folder
  bool active = true;

  Topic();
  Topic.n(this.date, this.userID, this.title, this.active, {this.folderId});

  Future<String?> createTopic(String userId, String date, String title, bool active, {String? folderId}) async {
    try {
      Map<String, dynamic> data = {
        "Title": title,
        "Date": date,
        "UserID": userId,
        "Active": true,
        "FolderID": folderId ?? "",
      };

      DocumentReference docRef = await FirebaseFirestore.instance.collection("Topic").add(data);
      print("Topic created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error creating topic: $e");
      return null;
    }
  }


  Future<List<Topic>> getTopics({String? folderId}) async {
    List<Topic> topicList = [];

    try {
      Query query = FirebaseFirestore.instance.collection('Topic');
      if (folderId != null) {
        query = query.where('folderId', isEqualTo: folderId);
      }

      QuerySnapshot querySnapshot = await query.get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String title = data['title'] ?? '';
          List<Map<String, String>> vocabularyList = List<Map<String, String>>.from(data['vocabularyList'] ?? []);
          String? folderId = data['folderId'];

          Topic topic = Topic.n(date, userID ,title, active, folderId: folderId);
          topicList.add(topic);
        }
      }
      return topicList;
    } catch (e) {
      print('Error getting topics: $e');
      return [];
    }
  }

  Future<void> deleteTopic(String topicTitle) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('topics')
          .where('title', isEqualTo: topicTitle)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Topic $topicTitle deleted successfully');
    } catch (e) {
      print('Error deleting topic: $e');
    }
  }
}