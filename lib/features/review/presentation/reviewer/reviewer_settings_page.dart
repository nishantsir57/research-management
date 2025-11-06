import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/providers/auth_controller.dart';

class ReviewerSettingsPage extends ConsumerStatefulWidget {
  const ReviewerSettingsPage({super.key});

  @override
  ConsumerState<ReviewerSettingsPage> createState() => _ReviewerSettingsPageState();
}

class _ReviewerSettingsPageState extends ConsumerState<ReviewerSettingsPage> {
  bool _availableForReviews = true;
  bool _newsletter = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentAppUserProvider);
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
