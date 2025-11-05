import 'package:flutter/material.dart';

class ReviewerPendingView extends StatelessWidget {
  const ReviewerPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviewer Verification'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Your reviewer profile is awaiting admin approval. '
            'You will receive a notification once approved.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
