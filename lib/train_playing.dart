import 'package:flutter/material.dart';

void main() => runApp(const PlayingBandApp());

class PlayingBandApp extends StatelessWidget {
  const PlayingBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlayingBandScreen(),
    );
  }
}

class PlayingBandScreen extends StatelessWidget {
  const PlayingBandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 28, 50, 1),
      body: Center(
        child: Image.asset(
          'assets/band.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
