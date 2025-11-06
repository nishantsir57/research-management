import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../submissions/controllers/submission_controller.dart';

class ReviewerDashboardPage extends StatelessWidget {
  const ReviewerDashboardPage({super.key});

  SubmissionController get _submissionController => Get.find<SubmissionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final assignments = _submissionController.reviewerAssignments;
      final history = _submissionController.reviewerHistory;

      final pending = assignments.length;
      final aiPending = assignments.where((paper) => paper.aiReview != null).length;
      final completed = history.length;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SummaryCard(
              icon: Icons.pending_actions_outlined,
              title: 'Pending Reviews',
              value: '$pending',
              detail: 'Awaiting your decision',
            ),
            _SummaryCard(
              icon: Icons.auto_fix_high_outlined,
              title: 'AI Suggestions',
              value: '$aiPending',
              detail: 'Pre-review summaries available',
            ),
            _SummaryCard(
              icon: Icons.history_outlined,
              title: 'Reviews Completed',
              value: '$completed',
              detail: 'Historical decisions and feedback',
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pearl50,
            ),
            child: Icon(icon, color: AppColors.indigo600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppColors.indigo700),
                ),
                const SizedBox(height: 6),
                Text(
                  detail,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
