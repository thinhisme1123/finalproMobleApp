
class TypeMode {
  final String engWord;
  final String vietWord;

  TypeMode({required this.engWord, required this.vietWord});

  bool checkAnswer(String input) {
    return (input.toLowerCase() == engWord.toLowerCase()) ? true : false;
  }
}
