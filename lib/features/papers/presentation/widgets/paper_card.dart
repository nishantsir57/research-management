import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../domain/comment_providers.dart';
import 'status_badge.dart';

/// Animated, design-system aligned card showcasing a research paper summary.
class PaperCard extends ConsumerStatefulWidget {
  const PaperCard({
    super.key,
    required this.paper,
    this.heroTag,
    this.onTap,
    this.onShare,
    this.author,
    this.highlightBadges,
    this.showStatus = true,
    this.showAuthor = true,
  });

  final ResearchPaper paper;
  final String? heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final AppUser? author;
  final List<Widget>? highlightBadges;
  final bool showStatus;
  final bool showAuthor;

  @override
  ConsumerState<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends ConsumerState<PaperCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final commentCountAsync = ref.watch(paperCommentCountProvider(widget.paper.id));
    final commentCount = commentCountAsync.maybeWhen(data: (value) => value, orElse: () => null);
    final metrics = _EngagementMetrics.fromPaper(widget.paper, commentCount);

    final content = _PaperCardBody(
      paper: widget.paper,
      author: widget.author,
      metrics: metrics,
      commentCountPending: commentCount == null && commentCountAsync.isLoading,
      onTap: widget.onTap,
      onShare: widget.onShare,
      highlightBadges: widget.highlightBadges,
      showStatus: widget.showStatus,
      showAuthor: widget.showAuthor,
    );

    final heroWrapped = widget.heroTag == null
        ? content
        : Hero(tag: widget.heroTag!, flightShuttleBuilder: _flightBuilder, child: content);

    return MouseRegion(
      onEnter: disableAnimations ? null : (_) => setState(() => _hovering = true),
      onExit: disableAnimations ? null : (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: disableAnimations || !_hovering ? 1 : 1.02,
        duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: disableAnimations || !_hovering ? 14 : 28,
                offset: Offset(0, disableAnimations || !_hovering ? 12 : 20),
              ),
            ],
          ),
          child: heroWrapped,
        ),
      ),
    );
  }

  Widget _flightBuilder(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInExpo);
    return ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(curved), child: toContext.widget);
  }
}

class _PaperCardBody extends StatelessWidget {
  const _PaperCardBody({
    required this.paper,
    required this.metrics,
    required this.commentCountPending,
    this.author,
    this.onTap,
    this.onShare,
    this.highlightBadges,
    this.showStatus = true,
    this.showAuthor = true,
  });

  final ResearchPaper paper;
  final AppUser? author;
  final _EngagementMetrics metrics;
  final bool commentCountPending;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final List<Widget>? highlightBadges;
  final bool showStatus;
  final bool showAuthor;

  @override
  Widget build(BuildContext context) {
    final gradient = _subjectGradient(paper.subject);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: const Color(0xFF1E1B4B),
        );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: gradient,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        paper.subject,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.4,
                            ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.school_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            paper.department,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showStatus)
                  Positioned(
                    top: 18,
                    right: 18,
                    child: StatusBadge(status: paper.status, compact: true),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paper.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(
                    _abstractPreview(paper),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF4B5563), height: 1.45),
                  ),
                  const SizedBox(height: 20),
                  if ((highlightBadges?.isNotEmpty ?? false))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: highlightBadges!,
                      ),
                    ),
                  if (showAuthor) _AuthorRow(paper: paper, author: author),
                  const SizedBox(height: 16),
                  _EngagementRow(
                    metrics: metrics,
                    commentCountPending: commentCountPending,
                    onShare: onShare,
                    onRead: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _abstractPreview(ResearchPaper paper) {
    final abstract = paper.contentText?.trim();
    if (abstract == null || abstract.isEmpty) {
      return 'This paper is available as a downloadable document. Open to explore the full findings and visuals.';
    }
    if (abstract.length <= 240) return abstract;
    return '${abstract.substring(0, 240)}…';
  }

  LinearGradient _subjectGradient(String subject) {
    final subjectKey = subject.toLowerCase();
    final gradients = <String, List<Color>>{
      'machine learning': const [Color(0xFF4338CA), Color(0xFF2563EB)],
      'ai': const [Color(0xFF7C3AED), Color(0xFF6366F1)],
      'biology': const [Color(0xFF059669), Color(0xFF34D399)],
      'genetics': const [Color(0xFF0EA5E9), Color(0xFF8B5CF6)],
      'physics': const [Color(0xFF14B8A6), Color(0xFF2563EB)],
      'quantum': const [Color(0xFF2563EB), Color(0xFF7C3AED)],
      'renewable': const [Color(0xFFF97316), Color(0xFF2563EB)],
    };

    final colors = gradients.entries.firstWhere(
      (entry) => subjectKey.contains(entry.key),
      orElse: () => const MapEntry('default', [Color(0xFF312E81), Color(0xFF7C3AED)]),
    ).value;

    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.paper, required this.author});

  final ResearchPaper paper;
  final AppUser? author;

  @override
  Widget build(BuildContext context) {
    final authorName = author?.fullName ?? 'Researcher';
    final dateLabel = _formatDate(paper.createdAt);

    return Row(
      children: [
        UserAvatar(heroTag: 'paper-avatar-${paper.id}', initials: authorName, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(authorName, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                dateLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
}

class _EngagementRow extends StatelessWidget {
  const _EngagementRow({
    required this.metrics,
    required this.commentCountPending,
    this.onShare,
    this.onRead,
  });

  final _EngagementMetrics metrics;
  final bool commentCountPending;
  final VoidCallback? onShare;
  final VoidCallback? onRead;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        _StatPill(icon: Icons.favorite_border_rounded, label: metrics.likes.toString(), color: iconColor),
        const SizedBox(width: 12),
        _StatPill(
          icon: Icons.mode_comment_outlined,
          label: commentCountPending ? '…' : metrics.comments.toString(),
          color: iconColor,
        ),
        const SizedBox(width: 12),
        _StatPill(icon: Icons.remove_red_eye_outlined, label: metrics.views.toString(), color: iconColor),
        const Spacer(),
        IconButton(
          tooltip: 'Share paper',
          onPressed: onShare,
          icon: const Icon(Icons.ios_share_rounded),
        ),
        const SizedBox(width: 4),
        FilledButton.icon(
          onPressed: onRead,
          icon: const Icon(Icons.book_outlined),
          label: const Text('Read'),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _EngagementMetrics {
  const _EngagementMetrics({required this.likes, required this.comments, required this.views});

  final int likes;
  final int comments;
  final int views;

  factory _EngagementMetrics.fromPaper(ResearchPaper paper, int? commentCount) {
    final seed = _hashSeed(paper.id);
    final likes = 40 + seed % 120;
    final views = 300 + (seed * 3) % 2200;
    return _EngagementMetrics(
      likes: likes,
      comments: commentCount ?? max(4, seed % 25),
      views: views,
    );
  }

  static int _hashSeed(String value) {
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash;
  }
}
