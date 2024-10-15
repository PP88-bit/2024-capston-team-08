import 'package:flutter/material.dart';

void main() => runApp(const TrainCompleteApp());

class TrainCompleteApp extends StatelessWidget {
  const TrainCompleteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TrainCompleteScreen(),
    );
  }
}

class TrainCompleteScreen extends StatelessWidget {
  const TrainCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(32, 28, 50, 1),
      body: Center(
        child: Text(
          '연습 완료!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
