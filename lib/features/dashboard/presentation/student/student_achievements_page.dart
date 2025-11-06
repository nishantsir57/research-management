import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../submissions/providers/submission_providers.dart';

class StudentAchievementsPage extends ConsumerStatefulWidget {
  const StudentAchievementsPage({super.key});

  @override
  ConsumerState<StudentAchievementsPage> createState() => _StudentAchievementsPageState();
}

class _StudentAchievementsPageState extends ConsumerState<StudentAchievementsPage> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final papersAsync = ref.watch(studentPapersProvider);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
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
                'Celebrate milestones in your research journey. Achievements unlock automatically as you submit and publish.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
              ),
              const SizedBox(height: 24),
              papersAsync.when(
                data: (papers) {
                  final achievements = _deriveAchievements(papers);
                  return Wrap(
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
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Failed to load achievements: $error'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_Achievement> _deriveAchievements(List<ResearchPaper> papers) {
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
        color: earned ? AppColors.indigo600.withOpacity(0.08) : Colors.white,
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
            backgroundColor: earned ? AppColors.success.withOpacity(0.2) : AppColors.gray100,
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
