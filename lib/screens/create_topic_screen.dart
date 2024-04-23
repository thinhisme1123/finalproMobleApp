import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';


class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _englishController = TextEditingController();
  final TextEditingController _vietnameseController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final OnDeviceTranslator _translator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.english,
    targetLanguage: TranslateLanguage.vietnamese,
  );

  @override
  void dispose() {
    _titleController.dispose();
    _englishController.dispose();
    _vietnameseController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _translateText(String text) async {
    final translation = await _translator.translateText(text);

    setState(() {
      _vietnameseController.text = translation;
    });
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText: 'English',
              ),
              onChanged: (value) {
                _speakText(value);
                _translateText(value);
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _vietnameseController,
              decoration: InputDecoration(
                labelText: 'Vietnamese',
              ),
            ),
          ],
        ),
      ),
    );
  }
}