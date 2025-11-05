import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/models/app_user.dart';
import '../../../shared/widgets/user_avatar.dart';

/// Animated threaded comment tile used across discussion feeds and paper detail pages.
class AnimatedDiscussionTile extends StatefulWidget {
  const AnimatedDiscussionTile({
    super.key,
    required this.author,
    required this.message,
    required this.publishedAt,
    this.depth = 0,
    this.onReply,
    this.actions,
    this.children = const <Widget>[],
  });

  final AppUser? author;
  final String message;
  final DateTime publishedAt;
  final int depth;
  final VoidCallback? onReply;
  final List<Widget>? actions;
  final List<Widget> children;

  @override
  State<AnimatedDiscussionTile> createState() => _AnimatedDiscussionTileState();
}

class _AnimatedDiscussionTileState extends State<AnimatedDiscussionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradients = Theme.of(context).extension<AppGradients>();
    final theme = Theme.of(context);
    final name = widget.author?.fullName ?? 'Guest Scholar';
    final timestamp = '${widget.publishedAt.day}/${widget.publishedAt.month}/${widget.publishedAt.year}';

    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: EdgeInsets.only(left: (widget.depth * 24).toDouble()),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: gradients?.surface,
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(initials: name, size: 32, heroTag: '${name.hashCode}-${widget.publishedAt.millisecondsSinceEpoch}'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: theme.textTheme.titleSmall),
                        Text(
                          timestamp,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (widget.actions?.isNotEmpty ?? false)
                    Row(mainAxisSize: MainAxisSize.min, children: widget.actions!),
                ],
              ),
              const SizedBox(height: 12),
              Text(widget.message, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (widget.onReply != null)
                    TextButton.icon(
                      onPressed: widget.onReply,
                      icon: const Icon(Icons.reply_rounded, size: 18),
                      label: const Text('Reply'),
                    ),
                ],
              ),
              if (widget.children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(children: widget.children),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
