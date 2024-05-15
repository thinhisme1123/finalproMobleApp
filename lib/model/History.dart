import 'package:cloud_firestore/cloud_firestore.dart';

class History{
  String userID = "";
  String topicID = "";
  String timeOpen = " ";
  String dateOpen = "";
  int count = 0;
  History();
  History.n(this.userID, this.dateOpen, this.timeOpen, this.topicID);

  Future<String?> createHistory(String userId, String dateOpen, String timeOpen, String topicId) async {
    try {
      Map<String, dynamic> data = {
        "DateOpen": dateOpen,
        "UserID": userId,
        "TimeOpen": timeOpen,
        "TopicID": topicId,
        "Count": 1
      };
      DocumentReference docRef = await FirebaseFirestore.instance.collection("History").add(data);
      print("History created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error creating history: $e");
      return null;
    }
  }
  Future<int> getCountByUserIDAndTopicID(String userID, String topicID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("History")
          .where("UserID", isEqualTo: userID)
          .where("TopicID", isEqualTo: topicID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If documents are found, return the count
        return querySnapshot.docs.first.get("Count");
      } else {
        // If no documents are found, return 0
        return 0;
      }
    } catch (e) {
      print("Error getting count by userID and topicID: $e");
      // Handle error
      throw e;
    }
  }

  Future<String?> updateHistoryDateTimeAndCount(String userID, String topicID, String newDate, String newTime) async {
    try {
      bool historyExists = await checkHistoryExists(userID, topicID);

      if (historyExists) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("History")
            .where("UserID", isEqualTo: userID)
            .where("TopicID", isEqualTo: topicID)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String docId = doc.id;
          int currentCount = doc.get("Count") ?? 0; // Lấy giá trị hiện tại của "Count"
          int newCount = currentCount + 1; // Tăng giá trị lên 1
          await FirebaseFirestore.instance
              .collection("History")
              .doc(docId)
              .update({"DateOpen": newDate, "TimeOpen": newTime, "Count": newCount}); // Cập nhật lại tài liệu với giá trị mới của "Count"
          print("History updated successfully with ID: $docId");
          return docId; // Trả về id của bản ghi lịch sử đã được cập nhật
        }
      } else {
        print("No history found for user with this topic.");
        return null;
      }
    } catch (e) {
      print("Error updating history: $e");
      return null;
    }
  }

  Future<bool> checkHistoryExists(String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("History")
          .where("UserID", isEqualTo: userId)
          .where("TopicID", isEqualTo: topicId)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking history: $e");
      return false;
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
  Future<List<Map<String, dynamic>>> getUserOpenedTopics_NoFolderID(String userID) async {
    List<Map<String, dynamic>> openedTopics = [];

    try {
      QuerySnapshot historySnapshot = await FirebaseFirestore.instance
          .collection('History')
          .where('UserID', isEqualTo: userID)
          .where("FolderID", isEqualTo: "folderID")
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