import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../domain/paper_providers.dart';
import '../paper_list_page.dart';

class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key, required this.user, required this.onSubmitPaper});

  final AppUser user;
  final VoidCallback onSubmitPaper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPapersAsync = ref.watch(userPapersProvider(user.uid));

    return userPapersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Unable to load your papers: $error')),
      data: (myPapers) {
        final stats = _aggregateStats(myPapers);
        return Column(
          children: [
            _GreetingBanner(user: user, onSubmitPaper: onSubmitPaper),
            const SizedBox(height: 16),
            _StatsRow(stats: stats),
            const SizedBox(height: 16),
            Expanded(
              child: PaperListPage(
                currentUser: user,
                header: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
                        ),
                        child: Icon(Icons.trending_up_rounded, color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trending Research',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Handpicked breakthroughs curated for you.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _StudentStats _aggregateStats(List<ResearchPaper> myPapers) {
    final published = myPapers.where((paper) => paper.status == PaperStatus.published).length;
    final totalHighlights = myPapers.fold<int>(0, (sum, paper) => sum + paper.reviewerHighlights.length);
    final totalResubmits = myPapers.fold<int>(0, (sum, paper) => sum + paper.studentResubmissions.length);
    final pseudoViews = myPapers.fold<int>(0, (sum, paper) {
      final seed = paper.id.codeUnits.fold<int>(0, (acc, code) => (acc * 31 + code) & 0x7fffffff);
      return sum + 260 + seed % 1800;
    });

    final reputation = (published * 120 + totalHighlights * 20 + totalResubmits * 12).clamp(120, 9999);

    return _StudentStats(
      published: published,
      totalViews: pseudoViews,
      reputation: reputation,
    );
  }
}

class _GreetingBanner extends StatelessWidget {
  const _GreetingBanner({required this.user, required this.onSubmitPaper});

  final AppUser user;
  final VoidCallback onSubmitPaper;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF4338CA), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1B4B).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${user.fullName.split(' ').first}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Discover new collaborations and keep your research orbit shining.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.84)),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: isCompact ? Alignment.centerLeft : Alignment.bottomRight,
                child: FilledButton.icon(
                  onPressed: onSubmitPaper,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4338CA),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  ),
                  label: const Text('Submit paper'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final _StudentStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cards = [
      _StatCardConfig(
        label: 'Papers Published',
        value: stats.published.toString(),
        colors: const [Color(0xFF4338CA), Color(0xFF2563EB)],
        icon: Icons.auto_graph_rounded,
      ),
      _StatCardConfig(
        label: 'Total Reach',
        value: '${(stats.totalViews / 1000).toStringAsFixed(1)}K',
        colors: const [Color(0xFF0EA5E9), Color(0xFF6366F1)],
        icon: Icons.podcasts_rounded,
      ),
      _StatCardConfig(
        label: 'Reputation',
        value: stats.reputation.toString(),
        colors: const [Color(0xFF7C3AED), Color(0xFF9333EA)],
        icon: Icons.workspace_premium_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isStacked = constraints.maxWidth < 720;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards
              .asMap()
              .entries
              .map(
                (entry) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: entry.key == 0 ? 16 : 8,
                      right: entry.key == cards.length - 1 ? 16 : 8,
                      bottom: isStacked ? 12 : 0,
                    ),
                    child: _StatCard(config: entry.value, theme: theme),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatCardConfig {
  const _StatCardConfig({
    required this.label,
    required this.value,
    required this.colors,
    required this.icon,
  });

  final String label;
  final String value;
  final List<Color> colors;
  final IconData icon;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.config, required this.theme});

  final _StatCardConfig config;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: config.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: config.colors.last.withOpacity(0.24), blurRadius: 22, offset: const Offset(0, 14)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(config.icon, color: Colors.white.withOpacity(0.85)),
          const SizedBox(height: 18),
          Text(
            config.value,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            config.label,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white.withOpacity(0.74)),
          ),
        ],
      ),
    );
  }
}

class _StudentStats {
  const _StudentStats({
    required this.published,
    required this.totalViews,
    required this.reputation,
  });

  final int published;
  final int totalViews;
  final int reputation;
}
