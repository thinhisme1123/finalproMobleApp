import 'package:cloud_firestore/cloud_firestore.dart';

import 'History.dart';

class Quizz_Achievement {
  String Quizz_AchievementID = "";
  String topicID = "";
  Map<String, dynamic> shortest = {};
  Map<String, dynamic> mostTime = {};
  Map<String, dynamic> mostCorrect = {};

  Quizz_Achievement.n(this.topicID, this.mostCorrect, this.mostTime, this.shortest);
  Quizz_Achievement();

  String getTime(){
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }
  String getDate(){
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }
  Future<String?> createQuizzAchievement(String topicId, Map<String, dynamic> shortest, Map<String, dynamic> mostTime, Map<String, dynamic> mostCorrect) async {
    try {
      Map<String, dynamic> data = {
        "TopicID": topicId,
        "Shortest": shortest,
        "MostTime": mostTime,
        "MostCorrect": mostCorrect,
      };
      DocumentReference docRef = await FirebaseFirestore.instance.collection("Quizz_Achievement").add(data);
      print("Quizz achievement created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error creating quizz achievement: $e");
      return null;
    }
  }
  Future<List<Quizz_Achievement>> loadByTopicID(String topicID) async {
    try {
      // Tạo truy vấn Firestore để lấy dữ liệu Quizz_Achievement dựa trên topicID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Type_Achievement")
          .where("TopicID", isEqualTo: topicID)
          .get();

      // Tạo danh sách để lưu trữ các đối tượng Quizz_Achievement
      List<Quizz_Achievement> typeAchievements = [];

      // Lặp qua từng tài liệu trong kết quả truy vấn
      querySnapshot.docs.forEach((doc) {
        // Tạo một đối tượng Quizz_Achievement từ dữ liệu tài liệu
        Quizz_Achievement quizzAchievement = Quizz_Achievement.n(
          doc["TopicID"],
          doc["MostCorrect"],
          doc["MostTime"],
          doc["Shortest"],
        );

        // Thêm đối tượng Quizz_Achievement vào danh sách
        typeAchievements.add(quizzAchievement);
      });

      // Trả về danh sách các đối tượng Quizz_Achievement
      return typeAchievements;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error loading Quizz_Achievement by topicID: $e");
      return [];
    }
  }

  Future<void> updateMostCorrect(String userID, String topicID, int correctAnswers) async {
    try {
      // Tìm và lấy ra tài liệu Type_Achievement dựa vào topicID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("TopicID", isEqualTo: topicID)
          .get();

      // Lặp qua từng tài liệu trong kết quả truy vấn (chỉ cần có 1 tài liệu do topicID là duy nhất)
      querySnapshot.docs.forEach((doc) async {
        // Lấy ra trường mostCorrect từ tài liệu
        Map<String, dynamic> mostCorrect = doc["MostCorrect"];

        // Lấy số câu đúng hiện tại từ trường mostCorrect
        int currentCorrectCount = mostCorrect['Result'] ?? 0;

        // Nếu số câu đúng mới lớn hơn số câu đúng hiện tại
        if (correctAnswers >= currentCorrectCount) {
          // Cập nhật trường mostCorrect với UserID mới và số câu đúng mới
          await doc.reference.update({
            'MostCorrect': {
              'UserID': userID,
              'Result': correctAnswers,
              "Date": getDate(),
              "Time": getTime(),
            },
          });
        }
      });
    } catch (e) {
      print('Error updating most correct count: $e');
      throw e;
    }
  }

  Future<void> updateMostTime(String userID, String topicID) async {
    try {
      // Load the count using the getCount function
      int time = await History().getCountByUserIDAndTopicID(userID, topicID);
      print("Count $time");
      // Query the Firestore collection to find Type_Achievement documents based on topicID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("TopicID", isEqualTo: topicID)
          .get();

      // Iterate through each document in the query result (there should be only one document since topicID is unique)
      querySnapshot.docs.forEach((doc) async {
        // Get the MostTime field from the document
        Map<String, dynamic> mostTime = doc["MostTime"];

        // Get the current count from the mostTime field
        int currentMostTime = mostTime['Result'] ?? 0;

        // If the new count is greater than or equal to the current count
        if (time >= currentMostTime) {
          // Update the currentMostTime field with the new UserID and count
          await doc.reference.update({
            'MostTime': {
              'UserID': userID,
              'Result': time,
              "Time": getTime(),
              "Date": getDate(),
            },
          });
        }
      });
    } catch (e) {
      print('Error updating most time: $e');
      throw e;
    }
  }
  int convertTimeStringToSeconds(String timeString) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }
  Future<void> updateShortest(String userID, String topicID, String timeString) async {
    try {
      int result = convertTimeStringToSeconds(timeString);
      print("time $result");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("TopicID", isEqualTo: topicID)
          .get();
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> currentShortest = doc["Shortest"];
        int currentShortestResult = currentShortest['Result'] ?? double.infinity.toInt();

        // Handle the case where currentShortestResult is 0 (no previous record)
        if (currentShortestResult == 0) {
          currentShortestResult = 9999999999999;
        }

        if (result < currentShortestResult) {
          print("true");
          await doc.reference.update({
            'Shortest': {
              'UserID': userID,
              'Result': result,
              "Date": getDate(),
              "Time": getTime(),
            },
          });
        }
      });
    } catch (e) {
      print('Error updating shortest quizz achievement: $e');
      throw e;
    }
  }
  Future<List<Map<String, dynamic>>> loadByUserID(String userID) async {
    try {
      // Tạo truy vấn Firestore để lấy dữ liệu Quizz_Achievement dựa trên userID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("MostCorrect.UserID", isEqualTo: userID)
          .get();

      List<Map<String, dynamic>> quizzAchievements = [];

      // Lặp qua từng tài liệu trong kết quả truy vấn cho MostCorrect
      querySnapshot.docs.forEach((doc) {
        quizzAchievements.add({
          'topicID': doc["TopicID"],
          'type': 'MostCorrect',
          'achievement': doc["MostCorrect"],
        });
      });

      // Truy vấn cho MostTime
      querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("MostTime.UserID", isEqualTo: userID)
          .get();

      // Lặp qua từng tài liệu trong kết quả truy vấn cho MostTime
      querySnapshot.docs.forEach((doc) {
        quizzAchievements.add({
          'topicID': doc["TopicID"],
          'type': 'MostTime',
          'achievement': doc["MostTime"],
        });
      });

      // Truy vấn cho Shortest
      querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("Shortest.UserID", isEqualTo: userID)
          .get();

      // Lặp qua từng tài liệu trong kết quả truy vấn cho Shortest
      querySnapshot.docs.forEach((doc) {
        quizzAchievements.add({
          'topicID': doc["TopicID"],
          'type': 'Shortest',
          'achievement': doc["Shortest"],
        });
      });

      return quizzAchievements;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error loading Quizz_Achievement by userID: $e");
      return [];
    }
  }
}
