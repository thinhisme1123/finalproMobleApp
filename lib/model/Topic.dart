import 'package:cloud_firestore/cloud_firestore.dart';

import 'History.dart';

class Topic {
  String title = '';
  String userID = '';
  String date = '';
  bool active = true;
  String topicID = "";
  int numberFlashcard = 0;
  Topic();
  Topic.n(this.date, this.userID, this.title, this.active,this.topicID);
  Topic.a(this.date, this.userID, this.title, this.active,this.topicID, this.numberFlashcard);

  String getTime(){
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }

  Future<String?> createTopic(String userId, String date, String title, bool active) async {
    try {
      Map<String, dynamic> data = {
        "Title": title,
        "Date": date,
        "UserID": userId,
        "Active": true,
      };

      DocumentReference docRef = await FirebaseFirestore.instance.collection("Topic").add(data);
      print("Topic created successfully with ID: ${docRef.id}");

      String? historyId = await History().createHistory(userId, date, getTime(),docRef.id);
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
  }
  // Future<String?> updateFolderID(String)
  Future<Topic?> getTopicByID(TopicID) async {
    try {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('Topic').doc(TopicID).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String id = docSnapshot.id;
          String title = data['Title'] ?? '';
          String folderId = data['FolderID'] ?? 'folderID';
          bool active = data['Active'] ?? false;
          String date = data['Date'] ?? '';
          String userId = data['UserID'] ?? '';
          Topic topic = Topic.n(date, userId, title, active,id);
          return topic;
        }
      }
      return null;
    } catch (e) {
      print('Error getting topic by ID: $e');
      return null;
    }
  }
  Future<List<Topic>> searchTopicByTitle(String title) async {
    try {
      List<Topic> topics = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Topic')
          .where('Title', isGreaterThanOrEqualTo: title)
          .where('Title', isLessThan: title + 'z')
          .where('Active', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          String id = docSnapshot.id;
          String topicTitle = data['Title'] ?? '';
          bool active = data['Active'] ?? false;
          String date = data['Date'] ?? '';
          String userId = data['UserID'] ?? '';
          int number = data['Number'] ?? 0;
          Topic topic = Topic.a(date, userId, topicTitle, active, id, number);
          topics.add(topic);
        }
      }
      return topics;
    } catch (e) {
      print('Error searching topic by title: $e');
      return [];
    }
  }


  Future<void> updateNumber(int number, String topicID) async{
    try {
      await FirebaseFirestore.instance.collection("Topic").doc(topicID).update({
        "Number": number,
      });

      print("Number updated successfully");
    } catch (e) {
      print("Error updating number: $e");
    }
  }

  // Future<void> updateTopic(String topicId, String newTitle, List<Map<String, String>> newVocabularyList) async {
  //   try {
  //     await FirebaseFirestore.instance.collection("topics").doc(topicId).update({
  //       "title": newTitle,
  //       "vocabularyList": newVocabularyList,
  //     });
  //
  //     print("Topic updated successfully");
  //   } catch (e) {
  //     print("Error updating topic: $e");
  //   }
  // }
  Future<List<Topic>> getTopicsByUserID(String userID) async {
    List<Topic> topicList = [];
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Topic').where("UserID", isEqualTo: userID).get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String id = document.id;
          String title = data['Title'] ?? '';
          bool active = data['Active'] ?? false;
          String date = data['Date'] ?? '';
          String userId = data['userID'] ?? '';
          int number = data['Number'] ?? 0;
          Topic topic = Topic.a(date, userId, title, active,id, number);
          topicList.add(topic);
        }
      }
      return topicList;
    } catch (e) {
      print('Error getting topics: $e');
      return [];
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

          Topic topic = Topic.n(date, userId, title, active,id);
          topicList.add(topic);
        }
      }
      return topicList;
    } catch (e) {
      print('Error getting topics: $e');
      return [];
    }
  }
  Future<List<Topic>> getTopicsByFolderID(String folderId) async {
    List<Topic> topicList = [];
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Folder').doc(folderId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          List<String> topicIDs = List<String>.from(data['TopicID'] ?? []);
          for (String topicId in topicIDs) {
            Topic? topic = await Topic().getTopicByID(topicId);
            if (topic != null) {
              topicList.add(topic);
            }
          }
        }
      }
    } catch (e) {
      print('Error getting topics by folder ID: $e');
    }
    return topicList;
  }

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