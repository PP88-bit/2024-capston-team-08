import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Training Screen'),
      ),
    );
  }
}
