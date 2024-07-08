import 'dart:async';

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Function onTimerFinish;
  final int duration;

  const CountDownTimer(
      {super.key, required this.onTimerFinish, required this.duration});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late Timer _timer;
  late Duration myDuration;

  @override
  void initState() {
    super.initState();
    myDuration = Duration(minutes: widget.duration);
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        _timer.cancel();
        widget.onTimerFinish(); // Notify parent widget when the timer finishes
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() => _timer.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: 1));
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(widget.duration));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Container(
      child: Text(
        '$minutes:$seconds',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
      ),
    );
  }
}
