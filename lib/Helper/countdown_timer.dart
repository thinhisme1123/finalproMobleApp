import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  final int color;
  final Function(String) onTimeUpdate;
  
  const CountUpTimer({Key? key, required this.color, required this.onTimeUpdate})
      : super(key: key);

  @override
  _CountUpTimerState createState() => _CountUpTimerState();

  // New method to get the current time value
  String getCurrentTime() {
    final state = this.createState() as _CountUpTimerState;
    return state.time;
  }
}

class _CountUpTimerState extends State<CountUpTimer> {
  

  Duration _duration = Duration.zero;
  Timer? _timer;
  String time = '';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration += Duration(seconds: 1);
        String time = getFormattedDuration(); // Get formatted time
        widget.onTimeUpdate(time); 
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
