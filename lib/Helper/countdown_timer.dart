import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  const CountUpTimer({Key? key}) : super(key: key);

  @override
  _CountUpTimerState createState() => _CountUpTimerState();
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

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(_duration.inHours.remainder(24));
    String minutes = twoDigits(_duration.inMinutes.remainder(60));
    String seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}