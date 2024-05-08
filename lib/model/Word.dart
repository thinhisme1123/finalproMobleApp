import 'package:cloud_firestore/cloud_firestore.dart';

class Word {
  String topicID = "";
  String engWord  = "";
  String vietWord = "";

  Word();
  Word.n(this.topicID, this.engWord, this.vietWord);

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
          Word word = Word.n(topicID, engWord, vietWord);
          wordList.add(word);
        }
      }
      return wordList;
    } catch (e) {
      print('Error getting words: $e');
      return [];
    }
  }
}