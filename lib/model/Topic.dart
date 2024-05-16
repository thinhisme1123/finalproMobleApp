import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/model/Type_Achievement.dart';

import 'History.dart';
import 'Quizz_Achievement.dart';
import 'Word.dart';

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
  String getDate(){
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
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
      String? Quizz_AID = await Quizz_Achievement().createQuizzAchievement(docRef.id,
        {
          'Date': getDate(),
          'Time': getTime(),
          'Result': 0,
          'UserID': '',
        },
        {
          'Date': getDate(),
          'Time': getTime(),
          'Result': 0,
          'UserID': userId,
        },
        {
          'Date': getDate(),
          'Time': getTime(),
          'Result': 0,
          'UserID': "",
        },
      );
      if (Quizz_AID != null){
        print("Quizz_Achievement created successfully with ID: $Quizz_AID");
      } else{
        print("Error creating Quizz_achievement for topic")  ;
      }
      String? Type_AID = await Type_Achievement().createTypeAchievement(docRef.id, {
        'Date': getDate(),
        'Time': getTime(),
        'Result': 0,
        'UserID': '',
      },
        {
          'Date': getDate(),
          'Time': getTime(),
          'Result': 1,
          'UserID': userId,
        },
        {
          'Date': getDate(),
          'Time': getTime(),
          'Result': 0,
          'UserID': '',
        },
      );
      if (Type_AID != null){
        print("Type_Achievement created successfully with ID: $Type_AID");
      }else{
        print("Error creating Type_achievement for topic");
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
          int number = data["Number"] ?? 0;
          Topic topic = Topic.a(date, userId, title, active,id, number);
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
  Future<String?> getTitleByID(TopicID) async{
    try{
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('Topic').doc(TopicID).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          String title = data['Title'] ?? '';
          return title;
        }
      }
      return null;
    }catch(e){
      print("Error getting title by ID: $e");
      return null;
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

  Future<void> updateTopicAndWord(String topicId, String newTitle, int number, bool active, List<Map<String, String>> newVocabularyList)  async {
    try{
      try {
        await FirebaseFirestore.instance.collection("Topic").doc(topicId).update({
          "Title": newTitle,
          "Active": active,
          "Number": number
        });
        print("Topic updated successfully");
      } catch (e) {
        print("Error updating topic: $e");
      }
      for (var vocabMap in newVocabularyList) {
        String wordId = vocabMap["wordID"]!; // Lấy ID của từ
        String newEngWord = vocabMap["english"]!;
        String newVietWord = vocabMap["vietnamese"]!;
        await Word().updateWord(wordId, newEngWord, newVietWord);
      }
    }catch(e){
      print("Topic and word updated successfully");
    }
  }
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