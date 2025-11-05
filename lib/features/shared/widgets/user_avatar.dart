import 'package:flutter/material.dart';

/// Rounded avatar widget with coloured fallback when no image is provided.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.initials,
    this.imageUrl,
    this.size = 48,
    this.onTap,
    this.heroTag,
  });

  final String? heroTag;
  final String initials;
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: SizedBox.square(
          dimension: size,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(imageUrl!, fit: BoxFit.cover)
              : Center(
                  child: Text(
                    _initialsFallback(initials),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
        ),
      ),
    );

    final heroWrapped = heroTag == null
        ? avatar
        : Hero(tag: heroTag!, flightShuttleBuilder: _flightShuttleBuilder, child: avatar);

    if (onTap == null) return heroWrapped;
    return GestureDetector(onTap: onTap, child: heroWrapped);
  }

  Widget _flightShuttleBuilder(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween<double>(begin: 0.95, end: 1.0) // Explicitly set to double
            .chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: toContext.widget,
    );

  }

  String _initialsFallback(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'R';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    final result = '$first$last';
    return result.isEmpty ? 'R' : result.toUpperCase();
  }
}
