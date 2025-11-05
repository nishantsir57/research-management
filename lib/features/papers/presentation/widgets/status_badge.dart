import 'package:flutter/material.dart';

import '../../../../../core/models/research_paper.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.compact = false});

  final PaperStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final config = _statusVisuals(context);
    final padding = compact ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6) : const EdgeInsets.symmetric(horizontal: 14, vertical: 8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: padding,
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: config.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: config.shadow.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: compact ? 16 : 18, color: config.foreground),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: config.foreground,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    );
  }

  _BadgeVisuals _statusVisuals(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case PaperStatus.submitted:
        return _BadgeVisuals(
          label: 'Submitted',
          icon: Icons.insert_drive_file_rounded,
          background: const Color(0xFFEFF4FF),
          border: const Color(0xFFD0DAFF),
          foreground: scheme.primary,
          shadow: const Color(0xFF3B4DD0),
        );
      case PaperStatus.aiReview:
        return _BadgeVisuals(
          label: 'AI Review',
          icon: Icons.auto_awesome_rounded,
          background: const Color(0xFFF2F1FF),
          border: const Color(0xFFE0DEFF),
          foreground: const Color(0xFF7C3AED),
          shadow: const Color(0xFF6D28D9),
        );
      case PaperStatus.underReview:
        return _BadgeVisuals(
          label: 'Under Review',
          icon: Icons.visibility_outlined,
          background: const Color(0xFFFFF7E5),
          border: const Color(0xFFFDE4AD),
          foreground: const Color(0xFFB45309),
          shadow: const Color(0xFFFACC15),
        );
      case PaperStatus.reverted:
        return _BadgeVisuals(
          label: 'Revisions Needed',
          icon: Icons.sync_problem_rounded,
          background: const Color(0xFFFFEEF0),
          border: const Color(0xFFFBB6C2),
          foreground: const Color(0xFFBE123C),
          shadow: const Color(0xFFFB7185),
        );
      case PaperStatus.approved:
        return _BadgeVisuals(
          label: 'Approved',
          icon: Icons.verified_rounded,
          background: const Color(0xFFE9FBF3),
          border: const Color(0xFFB7F0D3),
          foreground: const Color(0xFF047857),
          shadow: const Color(0xFF34D399),
        );
      case PaperStatus.published:
        return _BadgeVisuals(
          label: 'Published',
          icon: Icons.public_rounded,
          background: const Color(0xFFF3F0FF),
          border: const Color(0xFFDCD4FF),
          foreground: const Color(0xFF5B21B6),
          shadow: const Color(0xFF8B5CF6),
        );
    }
  }
}

class _BadgeVisuals {
  const _BadgeVisuals({
    required this.label,
    required this.icon,
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color border;
  final Color foreground;
  final Color shadow;
}
