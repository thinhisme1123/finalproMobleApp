import '../flashcard-mode/flashcard.dart';

class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer(this.answerText, this.isCorrect);
}

List<Question> generateQuiz(List<Flashcard> flashcards) {
  List<Question> quiz = [];

  // Loop through each flashcard
  for (var flashcard in flashcards) {
    // Shuffle the flashcards (excluding the current one)
    List<Flashcard> shuffledFlashcards = List.from(flashcards);
    shuffledFlashcards.remove(flashcard);
    shuffledFlashcards.shuffle();

    // Take three random flashcards (exclude the current one) to use as wrong answers
    List<Flashcard> wrongFlashcards = shuffledFlashcards.take(3).toList();

    // Create a list of answers (one correct and three wrong)
    List<Answer> answers = [
      Answer(flashcard.answer, true), // Correct answer
      for (var wrongFlashcard in wrongFlashcards)
        Answer(wrongFlashcard.answer, false) // Wrong answers
    ];

    // Shuffle the answers
    answers.shuffle();

    // Create a question with the question text being the English word
    Question question = Question(flashcard.question, answers);

    // Add the question to the quiz
    quiz.add(question);
  }

  return quiz;
}