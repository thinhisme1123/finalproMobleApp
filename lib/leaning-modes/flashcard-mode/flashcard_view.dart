import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;
  const FlashcardView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24.0,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}