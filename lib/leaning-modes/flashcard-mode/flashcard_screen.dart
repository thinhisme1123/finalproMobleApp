import 'package:flutter/material.dart';
import '../../model/Word.dart';
import 'flashcard.dart';
import 'flashcard_view.dart';
import 'package:flip_card/flip_card.dart';


class FlashCardScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  // List<Flashcard> _flashcards = [
  //   Flashcard(
  //       question: "What programming language does Flutter use?",
  //       answer: "Dart"),
  //   Flashcard(question: "Who you gonna call?", answer: "Ghostbusters!"),
  //   Flashcard(
  //       question: "Who teaches you how to write sexy code?",
  //       answer: "Ya boi Kilo Loco!")
  // ];
  // int _currentIndex = 0;
  late List<Flashcard> _flashcards;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> words = await Word().getWords();
    _flashcards = words.map((word) {
      return Flashcard(
        question: word.engWord,
        answer: word.vietWord,
      );
    }).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      backgroundColor: const Color(0xFF51C5F5),
        body: Center(
          child:_isLoading
            ? CircularProgressIndicator()
            : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  height: 250,
                  child: FlipCard(
                      key: ValueKey(_flashcards[_currentIndex]),
                      front: FlashcardView(
                        text: _flashcards[_currentIndex].question,
                      ),
                      back: FlashcardView(
                        text: _flashcards[_currentIndex].answer,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    onPressed: showPreviousCard,
                    icon: Icon(Icons.chevron_left),
                    label: Text('Prev'),
                  ),
                  Text(
                    '${_currentIndex + 1}/${_flashcards.length}'
                  ),
                  OutlinedButton.icon(
                    onPressed: showNextCard,
                    icon: Icon(Icons.chevron_right),
                    label: Text('Next'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showNextCard() {
    setState(() {
      _currentIndex =
          (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 >= 0) ? _currentIndex - 1 : _flashcards.length - 1;
    });
  }
}
// import 'package:flutter/material.dart';
// import '../../model/Word.dart';
// import 'flashcard.dart';
// import 'flashcard_view.dart';
// import 'package:flip_card/flip_card.dart';
//
// class FlashCardScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _FlashCardScreenState();
// }
//
// class _FlashCardScreenState extends State<FlashCardScreen> {
//   late List<Flashcard> _flashcards;
//   int _currentIndex = 0;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadWords();
//   }
//
//   Future<void> _loadWords() async {
//     List<Word> words = await Word().getWords();
//     _flashcards = words.map((word) {
//       return Flashcard(
//         question: word.engWord,
//         answer: word.vietWord,
//       );
//     }).toList();
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF51C5F5),
//       body: Center(
//         child: _isLoading
//             ? CircularProgressIndicator()
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 250,
//               height: 250,
//               child: FlipCard(
//                 front: FlashcardView(
//                   text: _flashcards[_currentIndex].question,
//                 ),
//                 back: FlashcardView(
//                   text: _flashcards[_currentIndex].answer,
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 OutlinedButton.icon(
//                   onPressed: showPreviousCard,
//                   icon: Icon(Icons.chevron_left),
//                   label: Text('Prev'),
//                 ),
//                 OutlinedButton.icon(
//                   onPressed: showNextCard,
//                   icon: Icon(Icons.chevron_right),
//                   label: Text('Next'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showNextCard() {
//     setState(() {
//       _currentIndex =
//       (_currentIndex + 1 < _flashcards.length) ? _currentIndex + 1 : 0;
//     });
//   }
//
//   void showPreviousCard() {
//     setState(() {
//       _currentIndex = (_currentIndex - 1 >= 0)
//           ? _currentIndex - 1
//           : _flashcards.length - 1;
//     });
//   }
// }
