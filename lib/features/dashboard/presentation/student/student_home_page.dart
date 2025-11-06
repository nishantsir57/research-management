import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/controllers/settings_controller.dart';
import '../../../submissions/controllers/submission_controller.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  SubmissionController get _submissionController => Get.find<SubmissionController>();
  SettingsController get _settingsController => Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final papers = _submissionController.studentPapers;
      final settings = _settingsController.settings.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Manage your research submissions, track reviewer feedback, and stay in sync with the community.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            _MetricsRow(papers: papers),
            const SizedBox(height: 24),
            _SettingsBanner(settings: settings),
            const SizedBox(height: 28),
            Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _RecentActivityList(papers: papers),
          ],
        ),
      );
    });
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.papers});

  final List<ResearchPaper> papers;

  @override
  Widget build(BuildContext context) {
    final active = papers.where((paper) => !paper.isPublished).length;
    final published = papers.where((paper) => paper.isPublished).length;
    final revisions =
        papers.where((paper) => paper.status == PaperStatus.revisionsRequested).length;
    final aiReviewed = papers.where((paper) => paper.aiReview != null).length;

    final cards = [
      const _StatCard(
        title: 'Active submissions',
        icon: Icons.pending_actions_outlined,
        description: 'Awaiting review or decision',
      ),
      const _StatCard(
        title: 'Published papers',
        icon: Icons.workspace_premium_outlined,
        description: 'Visible to peers based on privacy',
      ),
      const _StatCard(
        title: 'Revisions requested',
        icon: Icons.refresh_outlined,
        description: 'Requires updates before approval',
      ),
      const _StatCard(
        title: 'AI reviewed',
        icon: Icons.auto_awesome_outlined,
        description: 'Received Gemini pre-review insights',
      ),
    ];

    final values = ['$active', '$published', '$revisions', '$aiReviewed'];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        cards.length,
        (index) => cards[index].copyWith(value: values[index]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.description,
    required this.icon,
    this.value,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? value;

  _StatCard copyWith({String? value}) => _StatCard(
        title: title,
        description: description,
        icon: icon,
        value: value ?? this.value,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray200),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 16),
            color: Color.fromARGB(20, 30, 27, 75),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.indigo600),
          const SizedBox(height: 12),
          Text(
            value ?? '0',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.indigo700, fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.gray500, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SettingsBanner extends StatelessWidget {
  const _SettingsBanner({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFF6F4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.indigo700),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              settings.aiPreReviewEnabled
                  ? 'AI pre-review is currently enabled. Your submissions receive instant feedback before human review.'
                  : 'AI pre-review is currently disabled. Submissions go directly to reviewers.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.indigo700,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList({required this.papers});

  final List<ResearchPaper> papers;

  @override
  Widget build(BuildContext context) {
    if (papers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_empty_outlined, color: AppColors.gray500),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You have not submitted any research papers yet. Start by submitting your first paper.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }

    final sorted = [...papers]
      ..sort(
        (a, b) => (b.updatedAt ?? b.submittedAt ?? DateTime(0))
            .compareTo(a.updatedAt ?? a.submittedAt ?? DateTime(0)),
      );

    return Column(
      children: sorted.take(5).map((paper) => _ActivityTile(paper: paper)).toList(),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.paper});

  final ResearchPaper paper;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(paper.status);
    final statusText = paper.status.label;

    return GestureDetector(
      onTap: () => Get.toNamed('${AppRoutes.paperDetail}/${paper.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_statusIcon(paper.status), color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paper.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Department ${paper.departmentId} • Subject ${paper.subjectId}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.gray500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Chip(
              label: Text(statusText),
              backgroundColor: statusColor.withValues(alpha: 0.14),
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(PaperStatus status) {
    switch (status) {
      case PaperStatus.submitted:
      case PaperStatus.underReview:
        return AppColors.indigo600;
      case PaperStatus.aiReview:
        return AppColors.info;
      case PaperStatus.revisionsRequested:
        return AppColors.warning;
      case PaperStatus.approved:
      case PaperStatus.published:
        return AppColors.success;
      case PaperStatus.rejected:
        return AppColors.error;
      case PaperStatus.draft:
        return AppColors.gray500;
    }
  }

  IconData _statusIcon(PaperStatus status) {
    switch (status) {
      case PaperStatus.submitted:
      case PaperStatus.underReview:
        return Icons.pending_actions_outlined;
      case PaperStatus.aiReview:
        return Icons.auto_awesome_outlined;
      case PaperStatus.revisionsRequested:
        return Icons.feedback_outlined;
      case PaperStatus.approved:
      case PaperStatus.published:
        return Icons.workspace_premium_outlined;
      case PaperStatus.rejected:
        return Icons.block_outlined;
      case PaperStatus.draft:
        return Icons.edit_outlined;
    }
  }
}
