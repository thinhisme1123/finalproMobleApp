import 'package:finalproject/Helper/countdown_timer.dart';
import 'package:finalproject/Helper/learning_mode_data.dart';
import 'package:finalproject/model/Quizz_Achievement.dart';
import 'package:finalproject/screens/achievment_topic_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Helper/SharedPreferencesHelper.dart';
import '../../model/Word.dart';
import '../flashcard-mode/flashcard.dart';
import 'question_model.dart';

class QuizScreen extends StatefulWidget {
  final String topicID;
  final String userID;
  const QuizScreen({Key? key, required this.topicID, required this.userID}) : super(key: key);
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  //define the datas
  // List<Question> questionList = getQuestions();
  late List<Question> questionList;
  int questionLength = 0;
  late List<Flashcard> _flashcards;
  bool _isLoading = true;
  String time = '';
  late String userID;
  late String topicID;
  bool _timerRunning = true;


  void initState() {
    super.initState();
    _initSharedPreferences();
    topicID = widget.topicID;
    _loadWords();
  }
  Future<void> _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    String newUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String newEmail = await sharedPreferencesHelper.getEmail() ?? "";
    userID = await sharedPreferencesHelper.getUserID() ?? '';
    // email = await sharedPreferencesHelper.getEmail() ?? "";
    setState(() {
      userID = newUserID;
      // email = newEmail;
      print("id $userID");
      // print("email $email");
    });
  }
  Future<void> _loadWords() async {
    List<Word> words = await Word().getWordsByTopicID(widget.topicID);
    _flashcards = words.map((word) {
      return Flashcard(
        question: word.engWord,
        answer: word.vietWord,
      );
    }).toList();
    setState(() {
      _isLoading = false;
    });
    loadQuizz(); //
  }

  void loadQuizz() {
    questionList = generateQuiz(_flashcards);
    questionLength = _flashcards.length;
  }

  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CountUpTimer(
                    color: 0xFFFFFFFF,
                    onTimeUpdate: (updatedTime) {
                      if (_timerRunning) {
                        setState(() {
                          time = updatedTime;
                        });
                      }
                    },
                  ),
                  const Text(
                    "Quizz",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Driff',
                      fontSize: 30,
                    ),
                  ),
                  _questionWidget(),
                  _answerList(),
                  _nextButton(),
                ],
              ),
            ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: isSelected ? Colors.orangeAccent : Colors.white,
        ),
        onPressed: () {
          if (selectedAnswer == null || selectedAnswer != answer) {
            if (answer.isCorrect) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
            });
          } else {
            setState(() {
              selectedAnswer = null;
            });
          }
        },
        child: Text(
          answer.answerText,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 55,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (isLastQuestion) {
            //display score
            Quizz_Achievement().updateMostCorrect(userID, topicID, score);
            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            //next question
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;
    _timerRunning = false;
    if (score >= questionList.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    String title = isPassed ? "Passed " : "Failed";
    
    return AlertDialog(
      title: Text(
        title +
            " | Score is $score/$questionLength | Time you complete is $time",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("View Achievement"),
              onPressed: () {
                // Move to achievement page
                Get.to(AchievementType(type: "Quizz", userID: "userID", topicID: topicID));
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            SizedBox(height: 10), // Add some vertical spacing
            ElevatedButton(
              child: const Text("Restart"),
              onPressed: () {
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  selectedAnswer = null;
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        ),
      ),
    );
  }
}
