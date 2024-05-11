import 'package:cloud_firestore/cloud_firestore.dart';

class History{
  String userID = "";
  String topicId = "";
  String folderID = "";
  String timeOpen = " ";
  String dateOpen = "";
  History();
  History.n(this.userID, this.dateOpen, this.timeOpen, this.folderID, this.topicId);

  Future<String?> createHistory(String userId, String dateOpen, String timeOpen, String folderID, String topicId) async {
    try {
      Map<String, dynamic> data = {
        "FolderID": folderID,
        "DateOpen": dateOpen,
        "UserID": userId,
        "TimeOpen": timeOpen,
        "TopicID": topicId,
      };

      DocumentReference docRef = await FirebaseFirestore.instance.collection("History").add(data);
      print("History created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error creating history: $e");
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getUserOpenedTopics(String userID) async {
    List<Map<String, dynamic>> openedTopics = [];

    try {
      QuerySnapshot historySnapshot = await FirebaseFirestore.instance
          .collection('History')
          .where('UserID', isEqualTo: userID)
          .get();

      // Lặp qua mỗi bản ghi lịch sử và trích xuất thông tin cần thiết
      for (var historyDoc in historySnapshot.docs) {
        String topicID = historyDoc['TopicID'];
        String dateOpen = historyDoc['DateOpen'];
        String timeOpen = historyDoc['TimeOpen'];

        DocumentSnapshot topicSnapshot = await FirebaseFirestore.instance
            .collection('Topic')
            .doc(topicID)
            .get();

        if (topicSnapshot.exists) {
          Map<String, dynamic> topicData = {
            'topicID': topicID,
            'title': topicSnapshot['Title'],
            'dateOpen': dateOpen,
            'timeOpen': timeOpen,
          };
          openedTopics.add(topicData);
        }
      }
    } catch (e) {
      print('Error getting user opened topics: $e');
    }
    return openedTopics;
  }
}