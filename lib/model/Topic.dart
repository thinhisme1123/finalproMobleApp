import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  String title = '';
  String userId = '';
  String date = '';
  // List<Map<String, String>> vocabularyList = [];
  String? folderId; // Optional folderId to associate the topic with a folder

  Topic();

  Topic.n(this.title, {this.folderId});

  Future<String?> createTopic(String title, String date,{String? folderId}) async {
    try {
      Map<String, dynamic> data = {
        "title": title,
        "date": date,
        if (folderId != null) "folderId": folderId,
      };

      await FirebaseFirestore.instance.collection("Topic").add(data);
      print("Topic created successfully");
      return null;
    } catch (e) {
      print("Error creating topic: $e");
      return 'Failed to create topic: $e';
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

          Topic topic = Topic.n(title, folderId: folderId);
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