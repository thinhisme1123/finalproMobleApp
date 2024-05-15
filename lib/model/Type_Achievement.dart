import 'package:cloud_firestore/cloud_firestore.dart';

class Type_Achievement {
  String Type_AchievementID = "";
  String topicID = "";
  Map<String, dynamic> shortest = {};
  Map<String, dynamic> mostTime = {};
  Map<String, dynamic> mostCorrect = {};

  Type_Achievement.n(this.topicID, this.mostCorrect, this.mostTime, this.shortest);
  Type_Achievement();


  Future<String?> createTypeAchievement(String topicId, Map<String, dynamic> shortest, Map<String, dynamic> mostTime, Map<String, dynamic> mostCorrect) async {
    try {
      Map<String, dynamic> data = {
        "TopicID": topicId,
        "Shortest": shortest,
        "MostTime": mostTime,
        "MostCorrect": mostCorrect,
      };
      DocumentReference docRef = await FirebaseFirestore.instance.collection("Type_Achievement").add(data);
      print("Type achievement created successfully with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error creating Type achievement: $e");
      return null;
    }
  }
  Future<List<Type_Achievement>> loadByTopicID(String topicID) async {
    try {
      // Tạo truy vấn Firestore để lấy dữ liệu typeAchievements dựa trên topicID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Quizz_Achievement")
          .where("TopicID", isEqualTo: topicID)
          .get();

      // Tạo danh sách để lưu trữ các đối tượng typeAchievements
      List<Type_Achievement> typeAchievements = [];

      // Lặp qua từng tài liệu trong kết quả truy vấn
      querySnapshot.docs.forEach((doc) {
        // Tạo một đối tượng typeAchievements từ dữ liệu tài liệu
        Type_Achievement quizzAchievement = Type_Achievement.n(
          doc["TopicID"],
          doc["MostCorrect"],
          doc["MostTime"],
          doc["Shortest"],
        );

        // Thêm đối tượng typeAchievements vào danh sách
        typeAchievements.add(quizzAchievement);
      });

      // Trả về danh sách các đối tượng typeAchievements
      return typeAchievements;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error loading Type_Achievement by topicID: $e");
      return [];
    }
  }
  Future<void> updateMostCorrect(String userID, String topicID, int correctAnswers) async {
    try {
      // Tìm và lấy ra tài liệu Type_Achievement dựa vào topicID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Type_Achievement")
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
            },
          });
        }
      });
    } catch (e) {
      print('Error updating most correct count: $e');
      throw e;
    }
  }
}
