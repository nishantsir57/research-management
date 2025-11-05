import 'package:flutter/material.dart';

import '../../../../../core/models/app_user.dart';
import '../paper_list_page.dart';

class StudentDiscoverView extends StatelessWidget {
  const StudentDiscoverView({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return PaperListPage(
      currentUser: user,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.travel_explore_rounded, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Discover Research',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Explore work from peers and connect with emerging ideas across the community.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
