import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _seconds = 1500; // 25 minutes
  bool _isActive = false;
  Timer? _timer;

  void _startTimer() {
    if (!_isActive) {
      _isActive = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_seconds > 0) {
              _seconds--;
            } else {
              _isActive = false;
              _timer?.cancel();
            }
          });
        }
      });
    }
  }

  void _pauseTimer() {
    if (_isActive) {
      _isActive = false;
      _timer?.cancel();
    } else {
      _startTimer();
    }
  }

  void _resetTimer() {
    setState(() {
      _seconds = 1500;
      _isActive = false;
      _timer?.cancel();
    });
  }

  bool get isPaused => !_isActive && _seconds < 1500;

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff85A389),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // header title
                const Text(
                  "Pomodoro Timer",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontStyle: FontStyle.italic),
                ),
                //sub header title
                const Text(
                  "Study for 20 minutes, take a break for 5 minutes, then study again for 20 minutes.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                // the pomodoro timer
                Text(
                  _formatTime(_seconds),
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //start/pause timer button
                    InkWell(
                      onTap: _isActive ? _pauseTimer : _startTimer,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _isActive ? Colors.green : Colors.orange,
                        ),
                        child: Text(
                          _isActive
                              ? 'pause'
                              : (isPaused ? 'Continue' : 'Start'),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    //reset timer button
                    InkWell(
                      onTap: _resetTimer,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red,
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Avoid Distractions at all cost!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
