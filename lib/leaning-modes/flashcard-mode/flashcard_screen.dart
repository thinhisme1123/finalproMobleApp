import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'flashcard.dart';
import 'flashcard_view.dart';
import 'package:flip_card/flip_card.dart';


class FlashCardScreen extends StatefulWidget {
  


  @override
  State<StatefulWidget> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  // store the values to here
  List<Flashcard> _flashcards = [
    Flashcard(
        question: "What programming language does Flutter use?",
        answer: "Dart"),
    Flashcard(question: "Who you gonna call?", answer: "Ghostbusters!"),
    Flashcard(
        question: "Who teaches you how to write sexy code?",
        answer: "Ya boi Kilo Loco!")
  ];
  PageController _pageViewController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    _pageViewController = PageController(initialPage: _currentIndex);
    super.initState();
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
        backgroundColor: const Color(0xFF51C5F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
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
                      ),
                    );
                  },
                ),
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
        ),
      ),
    );
  }

  void showNextCard() {
  setState(() {
    if (_currentIndex + 1 < _flashcards.length) {
      _currentIndex++;
      _pageViewController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
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

  void showPreviousCard() {
    setState(() {
      if (_currentIndex - 1 >= 0) {
        _currentIndex--;
        _pageViewController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linear);
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