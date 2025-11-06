import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/controllers/auth_controller.dart';

class ReviewerSettingsPage extends StatefulWidget {
  const ReviewerSettingsPage({super.key});

  @override
  State<ReviewerSettingsPage> createState() => _ReviewerSettingsPageState();
}

class _ReviewerSettingsPageState extends State<ReviewerSettingsPage> {
  bool _availableForReviews = true;
  bool _newsletter = false;

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser.value;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviewer preferences', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Update your availability and communication preferences.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                SwitchListTile(
                  value: _availableForReviews,
                  onChanged: (value) => setState(() => _availableForReviews = value),
                  title: const Text('Available for new assignments'),
                ),
                SwitchListTile(
                  value: _newsletter,
                  onChanged: (value) => setState(() => _newsletter = value),
                  title: const Text('Receive reviewer newsletter'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Reviewer status: ${user?.isReviewerApproved == true ? 'Approved' : 'Pending approval'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
