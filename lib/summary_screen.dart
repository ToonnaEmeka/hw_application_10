import 'package:flutter/material.dart';
import 'setup_screen.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const SummaryScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Summary')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $score/$totalQuestions',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupScreen(),
                ),
              ),
              child: const Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
