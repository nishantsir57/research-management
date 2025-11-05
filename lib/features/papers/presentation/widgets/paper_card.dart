import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../domain/comment_providers.dart';
import 'status_badge.dart';

class PaperCard extends ConsumerStatefulWidget {
  const PaperCard({
    super.key,
    required this.paper,
    this.heroTag,
    this.author,
    this.onTap,
    this.onShare,
    this.showAuthor = true,
    this.showStatus = true,
  });

  final ResearchPaper paper;
  final String? heroTag;
  final AppUser? author;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final bool showAuthor;
  final bool showStatus;

  @override
  ConsumerState<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends ConsumerState<PaperCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final commentCountAsync = ref.watch(paperCommentCountProvider(widget.paper.id));
    final commentCount = commentCountAsync.valueOrNull;

    final metrics = _EngagementMetrics.fromPaper(widget.paper, commentCount);
    final formattedDate = DateFormat('MMM d, y').format(widget.paper.createdAt);

    final card = Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverSection(paper: widget.paper, showStatus: widget.showStatus),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.paper.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF1E1B4B),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaPill(label: widget.paper.department, color: const Color(0xFF4338CA).withOpacity(0.12), textColor: const Color(0xFF4338CA)),
                      _MetaPill(label: widget.paper.subject, color: const Color(0xFF7C3AED).withOpacity(0.12), textColor: const Color(0xFF7C3AED)),
                      _MetaPill(label: formattedDate, color: const Color(0xFF0EA5E9).withOpacity(0.12), textColor: const Color(0xFF0EA5E9)),
                      _MetaPill(label: widget.paper.visibility.name.toUpperCase(), color: const Color(0xFF6366F1).withOpacity(0.12), textColor: const Color(0xFF6366F1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _abstractPreview(widget.paper),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF4B5563),
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            if (widget.showAuthor)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Divider(height: 28),
                    _AuthorRow(paper: widget.paper, author: widget.author),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: _ActionsBar(
                metrics: metrics,
                onShare: widget.onShare,
                onRead: widget.onTap,
                commentCountPending: commentCountAsync.isLoading && commentCount == null,
              ),
            ),
          ],
        ),
      ),
    );

    final heroWrapped = widget.heroTag == null
        ? card
        : Hero(tag: widget.heroTag!, child: card);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovering ? 0.08 : 0.04),
                blurRadius: _hovering ? 26 : 18,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: heroWrapped,
        ),
      ),
    );
  }

  String _abstractPreview(ResearchPaper paper) {
    final content = paper.contentText?.trim();
    if (content == null || content.isEmpty) {
      return 'This paper is available as a downloadable document. Tap to explore the findings and commentary.';
    }
    if (content.length <= 260) return content;
    return '${content.substring(0, 260)}…';
  }
}

class _CoverSection extends StatelessWidget {
  const _CoverSection({required this.paper, required this.showStatus});

  final ResearchPaper paper;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: _subjectGradient(paper.subject),
            ),
          ),
          Positioned(
            top: 18,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.school_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Featured Research', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
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
    );
  }

  LinearGradient _subjectGradient(String subject) {
    final key = subject.toLowerCase();
    const palettes = [
      _GradientMatch(pattern: 'machine', colors: [Color(0xFF4338CA), Color(0xFF2563EB), Color(0xFF7C3AED)]),
      _GradientMatch(pattern: 'ai', colors: [Color(0xFF7C3AED), Color(0xFF6366F1), Color(0xFF4F46E5)]),
      _GradientMatch(pattern: 'bio', colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF0EA5E9)]),
      _GradientMatch(pattern: 'physics', colors: [Color(0xFF14B8A6), Color(0xFF2563EB), Color(0xFF7C3AED)]),
      _GradientMatch(pattern: 'energy', colors: [Color(0xFFF97316), Color(0xFFF59E0B), Color(0xFF2563EB)]),
      _GradientMatch(pattern: 'block', colors: [Color(0xFF6366F1), Color(0xFF22D3EE), Color(0xFF0EA5E9)]),
    ];

    final match = palettes.firstWhere(
      (palette) => key.contains(palette.pattern),
      orElse: () => const _GradientMatch(
        pattern: 'default',
        colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF7C3AED)],
      ),
    );

    return LinearGradient(
      colors: match.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.color, required this.textColor});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.paper, required this.author});

  final ResearchPaper paper;
  final AppUser? author;

  @override
  Widget build(BuildContext context) {
    final name = author?.fullName ?? 'Researcher';
    final dateLabel = DateFormat('MMM d, y').format(paper.createdAt);
    final subtitle = switch (paper.status) {
      PaperStatus.published => 'Published $dateLabel',
      PaperStatus.approved => 'Approved $dateLabel',
      PaperStatus.reverted => 'Revisions requested $dateLabel',
      PaperStatus.underReview => 'Under review since $dateLabel',
      PaperStatus.aiReview => 'AI review started $dateLabel',
      PaperStatus.submitted => 'Submitted $dateLabel',
    };

    return Row(
      children: [
        UserAvatar(heroTag: 'paper-avatar-${paper.id}', initials: name, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({
    required this.metrics,
    required this.onShare,
    required this.onRead,
    required this.commentCountPending,
  });

  final _EngagementMetrics metrics;
  final VoidCallback? onShare;
  final VoidCallback? onRead;
  final bool commentCountPending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      _ActionButton(icon: Icons.favorite_border_rounded, label: metrics.likes.toString(), color: const Color(0xFFE11D48)),
      _ActionButton(
        icon: Icons.mode_comment_outlined,
        label: commentCountPending ? '…' : metrics.comments.toString(),
        color: const Color(0xFF2563EB),
      ),
      _ActionButton(icon: Icons.remove_red_eye_outlined, label: metrics.views.toString(), color: const Color(0xFF4338CA)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: [
            for (final action in actions) action,
            _ShareChip(onShare: onShare),
            _ReadButton(onTap: onRead, theme: theme),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        color: color.withOpacity(0.06),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareChip extends StatelessWidget {
  const _ShareChip({this.onShare});

  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onShare,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFFF4F3FF),
          border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.ios_share_rounded, color: Color(0xFF7C3AED), size: 18),
            SizedBox(width: 6),
            Text('Share', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ReadButton extends StatelessWidget {
  const _ReadButton({required this.onTap, required this.theme});

  final VoidCallback? onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4338CA), Color(0xFF2563EB), Color(0xFF7C3AED)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Color(0x663138A6), blurRadius: 18, offset: Offset(0, 10)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.book_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Read', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
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
    final likes = 80 + seed % 160;
    final views = 420 + (seed * 3) % 2800;
    return _EngagementMetrics(
      likes: likes,
      comments: commentCount ?? max(4, seed % 32),
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

class _GradientMatch {
  const _GradientMatch({required this.pattern, required this.colors});

  final String pattern;
  final List<Color> colors;
}
