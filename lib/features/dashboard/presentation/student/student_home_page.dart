import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/app_settings.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/providers/admin_settings_provider.dart';
import '../../../submissions/providers/submission_providers.dart';

class StudentHomePage extends ConsumerWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final papersAsync = ref.watch(studentPapersProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

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
          papersAsync.when(
            data: (papers) => _MetricsRow(papers: papers),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Unable to load statistics: $error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
          const SizedBox(height: 24),
          settingsAsync.when(
            data: (settings) => _SettingsBanner(settings: settings),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 28),
          Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          papersAsync.when(
            data: (papers) => _RecentActivityList(papers: papers),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Unable to load activity: $error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
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
      _StatCard(
        title: 'Active submissions',
        value: '$active',
        description: 'Awaiting review or decision',
        icon: Icons.pending_actions_outlined,
      ),
      _StatCard(
        title: 'Published papers',
        value: '$published',
        description: 'Visible to peers based on privacy',
        icon: Icons.workspace_premium_outlined,
      ),
      _StatCard(
        title: 'Revisions requested',
        value: '$revisions',
        description: 'Requires updates before approval',
        icon: Icons.refresh_outlined,
      ),
      _StatCard(
        title: 'AI reviewed',
        value: '$aiReviewed',
        description: 'Received Gemini pre-review insights',
        icon: Icons.auto_awesome_outlined,
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: cards,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
  });

  final String title;
  final String value;
  final String description;
  final IconData icon;

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

    final sorted = [...papers]..sort(
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

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.go('/student/paper/${paper.id}'),
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
                color: statusColor.withOpacity(0.12),
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
            backgroundColor: statusColor.withOpacity(0.14),
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
