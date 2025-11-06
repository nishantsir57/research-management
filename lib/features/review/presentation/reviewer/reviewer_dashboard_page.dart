import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../submissions/providers/submission_providers.dart';

class ReviewerDashboardPage extends ConsumerWidget {
  const ReviewerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(reviewerAssignmentsProvider);
    final historyAsync = ref.watch(reviewerHistoryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviewer dashboard', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Stay on top of pending reviews, leverage AI suggestions, and track your impact.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: 24),
          assignmentsAsync.when(
            data: (assignments) => historyAsync.when(
              data: (history) {
                final pending = assignments.length;
                final aiPending = assignments.where((paper) => paper.aiReview != null).length;
                final avgTurnaround = history.isEmpty
                    ? 0.0
                    : history
                            .map((paper) => paper.reviews
                                .where((review) => review.reviewerId == review.reviewerId)
                                .length)
                            .fold<double>(0.0, (prev, value) => prev + value) /
                        history.length;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      icon: Icons.pending_actions_outlined,
                      title: 'Pending reviews',
                      value: '$pending',
                      detail: 'Awaiting your decision',
                    ),
                    _StatCard(
                      icon: Icons.auto_fix_high_outlined,
                      title: 'AI insights ready',
                      value: '$aiPending',
                      detail: 'Pre-review summaries available',
                    ),
                    _StatCard(
                      icon: Icons.history_outlined,
                      title: 'Reviews completed',
                      value: '${history.length}',
                      detail: 'Average comments ${avgTurnaround.toStringAsFixed(1)}',
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Unable to load history: $error'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Unable to load assignments: $error'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.indigo600),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.indigo700, fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}
