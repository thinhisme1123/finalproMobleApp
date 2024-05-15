import 'package:cloud_firestore/cloud_firestore.dart';

class Word {
  String topicID = "";
  String engWord  = "";
  String vietWord = "";
  String wordID = "";
  Word();
  Word.n(this.topicID, this.engWord, this.vietWord);
  Word.a(this.topicID, this.engWord, this.vietWord, this.wordID);

  Future<String?> createWord(String topicId, String engWord, String vietWord) async {
    try {
      await FirebaseFirestore.instance.collection('Word').add({
        'TopicId': topicId,
        'EngWord': engWord,
        'VietWord': vietWord,
      });
      print('Word added successfully!');
      return "Word added successfully";
    } catch (e) {
      print('Error adding word: $e');
      return null;
    }
  }

  Future<void> deleteWordById(String wordID) async {
    try {
      await FirebaseFirestore.instance.collection('Word').doc(wordID).delete();
      print('Word deleted successfully!');
    } catch (e) {
      print('Error deleting word: $e');
    }
  }
  Future<List<Word>> getWordsByTopicID(String topicID) async {
    List<Word> wordList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Word').where("TopicId", isEqualTo: topicID).get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String topicID = data["TopicId"] ?? "";
          String engWord = data['EngWord'] ?? '';
          String vietWord = data['VietWord'] ?? '';
          String id = document.id;
          Word word = Word.a(topicID, engWord, vietWord,id);
          wordList.add(word);
        }
      }
      return wordList;
    } catch (e) {
      print('Error getting words: $e');
      return [];
    }
  }
  Future<void> updateWord(String wordId, String newEngWord, String newVietWord) async {
    try {
      await FirebaseFirestore.instance.collection("Word").doc(wordId).update({
        "EngWord": newEngWord,
        "VietWord": newVietWord,
        // Cập nhật các trường khác của word nếu cần
      });

      print("Word updated successfully");
    } catch (e) {
      print("Error updating word: $e");
    }
  }
}