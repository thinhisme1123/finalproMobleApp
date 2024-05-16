import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashcardView extends StatefulWidget {
  final String text;
  final VoidCallback? onFlip;

  const FlashcardView({Key? key, required this.text, this.onFlip})
      : super(key: key);

  @override
  _FlashcardViewState createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future _speakText(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: GestureDetector(
        onTap: () {
          _speakText(widget.text);
          widget.onFlip?.call();
        },
        child: Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    print(widget.text);
                  },
                  icon: Icon(
                    Icons.star,
                    size: 35,
                    color: isFavorite ? Colors.yellow : Colors.grey,
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
