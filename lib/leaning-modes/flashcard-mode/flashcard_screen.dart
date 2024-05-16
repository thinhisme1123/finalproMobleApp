import 'package:finalproject/Helper/countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../model/Word.dart';
import 'flashcard.dart';
import 'flashcard_view.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashCardScreen extends StatefulWidget {
  final String topicID;
  const FlashCardScreen({Key? key, required this.topicID}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  PageController _pageViewController = PageController();
  late List<Flashcard> _flashcards;
  int _currentIndex = 0;
  bool _isLoading = true;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: _currentIndex);
    _flutterTts = FlutterTts();
    _flutterTts = FlutterTts();
    _loadWords();
  }

  Future _speakText(String text) async {
    final containsVietnamese = RegExp(
        r'[àáạảãâầẩẫậăằắẳẵặèéẻẽẹêềếểễệìíỉĩịòóọỏõôồốổỗộơờớởỡợùúụủũưừứửữựỳýỷỹỵ]');
    final isVietnamese = containsVietnamese.hasMatch(text);

    if (isVietnamese) {
      await _flutterTts.setLanguage('vi-VN');
    } else {
      await _flutterTts.setLanguage('en-US');
    }
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
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
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF51C5F5),
          actions: [
          ], // Background color of the AppBar
        ),
        backgroundColor: const Color(0xFF51C5F5),
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 200,
                      child: PageView.builder(
                        controller: _pageViewController,
                        itemCount: _flashcards.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return FlipCard(
                            key: ValueKey(_flashcards[index]),
                            front: FlashcardView(
                              text: _flashcards[index].question,
                            ),
                            back: FlashcardView(
                              text: _flashcards[index].answer,
                              onFlip: () =>
                                  _speakText(_flashcards[index].answer),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton.icon(
                          onPressed: showPreviousCard,
                          icon: Icon(Icons.chevron_left),
                          label: Text('Prev'),
                        ),
                        Text(
                          '${_currentIndex + 1}/${_flashcards.length}',
                          style: TextStyle(fontSize: 20),
                        ),
                        OutlinedButton.icon(
                          onPressed: showNextCard,
                          icon: Icon(Icons.chevron_right),
                          label: Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
          // child: _isLoading
          //     ? CircularProgressIndicator()
          //     : Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           SizedBox(
          //             width: 300,
          //             height: 200,
          //             child: PageView.builder(
          //               controller: _pageViewController,
          //               itemCount: _flashcards.length,
          //               onPageChanged: (index) {
          //                 setState(() {
          //                   _currentIndex = index;
          //                 });
          //               },
          //               itemBuilder: (context, index) {
          //                 return FlipCard(
          //                   key: ValueKey(_flashcards[index]),
          //                   front: FlashcardView(
          //                     text: _flashcards[index].question,
          //                   ),
          //                   back: FlashcardView(
          //                     text: _flashcards[index].answer,
          //                     onFlip: () =>
          //                         _speakText(_flashcards[index].answer),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               OutlinedButton.icon(
          //                 onPressed: showPreviousCard,
          //                 icon: Icon(Icons.chevron_left),
          //                 label: Text('Prev'),
          //               ),
          //               Text(
          //                 '${_currentIndex + 1}/${_flashcards.length}',
          //                 style: TextStyle(fontSize: 20),
          //               ),
          //               OutlinedButton.icon(
          //                 onPressed: showNextCard,
          //                 icon: Icon(Icons.chevron_right),
          //                 label: Text('Next'),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
        ),
      ),
    );
  }

  void showNextCard() {
    setState(() {
      if (_currentIndex + 1 < _flashcards.length) {
        _currentIndex++;
        _pageViewController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      } else {
        _currentIndex = 0;
        _pageViewController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    });
  }
  //   setState(() {
  //     if (_currentIndex + 1 < _flashcards.length) {
  //       _currentIndex++;
  //       _pageViewController.nextPage(
  //           duration: Duration(milliseconds: 500), curve: Curves.linear);
  //     } else {
  //       _currentIndex = 0;
  //       _pageViewController.animateToPage(
  //         0,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.linear,
  //       );
  //     }
  //   });
  // }

  void showPreviousCard() {
    setState(() {
      if (_currentIndex - 1 >= 0) {
        _currentIndex--;
        _pageViewController.previousPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
        _pageViewController.previousPage(
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      } else {
        // If we are on the first flashcard, go to the last one
        _currentIndex = _flashcards.length - 1;
        // Animate to the last page
        _pageViewController.animateToPage(
          _flashcards.length - 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      }
    });
  }
}

