import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../submissions/controllers/submission_controller.dart';

class ReviewerHistoryPage extends StatelessWidget {
  const ReviewerHistoryPage({super.key});

  SubmissionController get _submissionController => Get.find<SubmissionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final history = _submissionController.reviewerHistory;
      if (history.isEmpty) {
        return const Center(child: Text('No review history yet.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final paper = history[index];
          final latestReview = paper.reviews.isNotEmpty ? paper.reviews.last : null;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paper.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    latestReview?.summary ?? 'Review summary unavailable',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Decision: ${latestReview?.decision.name ?? 'N/A'}')),
                      Chip(label: Text('Status: ${paper.status.label}')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
