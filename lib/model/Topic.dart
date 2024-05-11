import 'package:cloud_firestore/cloud_firestore.dart';

import 'History.dart';

class Topic {
  String title = '';
  String userID = '';
  String date = '';
  String? folderId; // Optional folderId to associate the topic with a folder
  bool active = true;
  String topicID = "";
  Topic();
  Topic.n(this.date, this.userID, this.title, this.active,this.topicID, {this.folderId});

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

      String? historyId = await History().createHistory(userId, date, DateTime.now().toString(),"",docRef.id);
      if (historyId != null) {
        print("History created successfully with ID: $historyId");
      } else {
        print("Error creating history for topic");
      }

      return docRef.id;
    } catch (e) {
      print("Error creating topic: $e");
      return null;
    }
  }  Future<Topic?> getTopicByID(TopicID) async {
    try {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('Topic').doc(TopicID).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String id = docSnapshot.id;
          String title = data['Title'] ?? '';
          String folderId = data['FolderID'] ?? '';
          bool active = data['Active'] ?? false;
          String date = data['Date'] ?? '';
          String userId = data['UserID'] ?? '';
          Topic topic = Topic.n(date, userId, title, active,id,folderId: folderId);
          return topic;
        }
      }
      return null;
    } catch (e) {
      print('Error getting topic by ID: $e');
      return null;
    }
  }

  Future<void> updateTopic(String topicId, String newTitle, List<Map<String, String>> newVocabularyList) async {
    try {
      await FirebaseFirestore.instance.collection("topics").doc(topicId).update({
        "title": newTitle,
        "vocabularyList": newVocabularyList,
      });

      print("Topic updated successfully");
    } catch (e) {
      print("Error updating topic: $e");
    }
  }

  Future<List<Topic>> getTopics() async {
    List<Topic> topicList = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Topic').get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String id = document.id;
          String title = data['Title'] ?? '';
          String folderId = data['FolderID'] ?? '';
          bool active = data['Active'] ?? false;
          String date = data['Date'] ?? '';
          String userId = data['userID'] ?? '';

          Topic topic = Topic.n(date, userId, title, active,id,folderId: folderId);
          topicList.add(topic);
        }
      }
      return topicList;
    } catch (e) {
      print('Error getting topics: $e');
      return [];
    }
  }
  // Future<List<Topic>> getTopicsByFolderID({String? folderId}) async {
  //   List<Topic> topicList = [];
  //
  //   try {
  //     Query query = FirebaseFirestore.instance.collection('Topic');
  //     if (folderId != null) {
  //       query = query.where('folderId', isEqualTo: folderId);
  //     }
  //
  //     QuerySnapshot querySnapshot = await query.get();
  //
  //     for (var document in querySnapshot.docs) {
  //       Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  //
  //       if (data != null) {
  //         String title = data['title'] ?? '';
  //         List<Map<String, String>> vocabularyList = List<Map<String, String>>.from(data['vocabularyList'] ?? []);
  //         String? folderId = data['folderId'];
  //
  //         Topic topic = Topic.n(date, userID ,title, active, folderId: folderId);
  //         topicList.add(topic);
  //       }
  //     }
  //     return topicList;
  //   } catch (e) {
  //     print('Error getting topics: $e');
  //     return [];
  //   }
  // }
  // Future<Topic?> getFolderByID(String folderId) async {
  //   try {
  //     DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Topic').doc(folderId).get();
  //
  //     if (docSnapshot.exists) {
  //       Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
  //
  //       if (data != null) {
  //         String id = document.id;
  //         String title = data['Title'] ?? '';
  //         String folderId = data['FolderID'] ?? '';
  //         bool active = data['Active'] ?? false;
  //         String date = data['Date'] ?? '';
  //         String userId = data['userID'] ?? '';
  //         Topic topic = Topic.n(title, description, userID , folderId);
  //         return topic;
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error getting folder by ID: $e');
  //     return null;
  //   }
  // }
  Future<void> deleteTopicByID(String topicID) async {
    try {
      await  FirebaseFirestore.instance.collection("Topic").doc(topicID).delete();
      print('Topic $topicID deleted successfully');
    } catch (e) {
      print('Error deleting Topic: $e');
    }
  }
}