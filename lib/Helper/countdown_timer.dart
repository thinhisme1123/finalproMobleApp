import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  final int color;

  
  const CountUpTimer({Key? key, required this.color}) : super(key: key);

  @override
  _CountUpTimerState createState() => _CountUpTimerState();
  String getFormattedDuration() {
    final state = this.createState() as _CountUpTimerState;
    return state.getFormattedDuration();
  }
}

class _CountUpTimerState extends State<CountUpTimer> {
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String getFormattedDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(_duration.inHours.remainder(24));
    String minutes = twoDigits(_duration.inMinutes.remainder(60));
    String seconds = twoDigits(_duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    Color timerColor = Color(widget.color);

    return Text(
      getFormattedDuration(),
      style: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.bold,
          color: timerColor),
    );
  }
}
