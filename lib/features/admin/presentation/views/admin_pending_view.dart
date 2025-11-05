import 'package:flutter/material.dart';

class AdminPendingView extends StatelessWidget {
  const AdminPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Verification'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Your admin privileges are awaiting approval from an existing administrator. '
            'Once an active admin verifies your account, you will gain access to the admin console.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
