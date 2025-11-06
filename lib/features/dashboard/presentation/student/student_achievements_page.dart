import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../submissions/controllers/submission_controller.dart';

class StudentAchievementsPage extends StatefulWidget {
  const StudentAchievementsPage({super.key});

  @override
  State<StudentAchievementsPage> createState() => _StudentAchievementsPageState();
}

class _StudentAchievementsPageState extends State<StudentAchievementsPage> {
  late ConfettiController _confettiController;

  final SubmissionController _submissionController = Get.find<SubmissionController>();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final achievements = _buildAchievements(_submissionController.studentPapers);

      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Achievements', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Celebrate milestones in your research journey.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: achievements
                      .map(
                        (achievement) => _AchievementCard(
                          title: achievement.title,
                          description: achievement.description,
                          earned: achievement.earned,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  List<_Achievement> _buildAchievements(List<ResearchPaper> papers) {
    final publishedCount = papers.where((paper) => paper.isPublished).length;
    final aiReviewed = papers.where((paper) => paper.aiReview != null).length;
    final revisionsHandled =
        papers.where((paper) => paper.status == PaperStatus.revisionsRequested).length;

    return [
      _Achievement(
        title: 'First Submission',
        description: 'Submit your first research paper.',
        earned: papers.isNotEmpty,
      ),
      _Achievement(
        title: 'Published Author',
        description: 'Publish at least one research paper.',
        earned: publishedCount >= 1,
      ),
      _Achievement(
        title: 'Peer Reviewed',
        description: 'Receive reviewer feedback on three papers.',
        earned: papers.where((paper) => paper.reviews.isNotEmpty).length >= 3,
      ),
      _Achievement(
        title: 'AI Assisted',
        description: 'Leverage AI pre-review on two submissions.',
        earned: aiReviewed >= 2,
      ),
      _Achievement(
        title: 'Resilience',
        description: 'Successfully resubmit after revisions.',
        earned: revisionsHandled > 0,
      ),
      _Achievement(
        title: 'Prolific Author',
        description: 'Publish five research papers.',
        earned: publishedCount >= 5,
      ),
    ];
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.title,
    required this.description,
    required this.earned,
  });

  final String title;
  final String description;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: earned ? AppColors.indigo600 : AppColors.gray200),
        color: earned ? AppColors.indigo600.withValues(alpha: 0.08) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            earned ? Icons.emoji_events_outlined : Icons.emoji_events,
            color: earned ? AppColors.indigo600 : AppColors.gray400,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: earned ? AppColors.indigo700 : AppColors.gray700),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: earned ? AppColors.gray600 : AppColors.gray500),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(earned ? 'Achieved' : 'In progress'),
            backgroundColor: earned ? AppColors.success.withValues(alpha: 0.2) : AppColors.gray100,
            labelStyle: TextStyle(
              color: earned ? AppColors.success : AppColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  const _Achievement({
    required this.title,
    required this.description,
    required this.earned,
  });

  final String title;
  final String description;
  final bool earned;
}
