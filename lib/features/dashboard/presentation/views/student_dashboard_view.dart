import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_user.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../papers/presentation/views/student/student_paper_submission_view.dart';
import '../../../papers/presentation/views/student/student_papers_overview_view.dart';
import '../../../social/presentation/views/discussions_view.dart';
import '../../../social/presentation/views/network_view.dart';
import '../../../papers/presentation/views/student/student_discover_view.dart';

class StudentDashboardView extends ConsumerStatefulWidget {
  const StudentDashboardView({super.key});

  @override
  ConsumerState<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends ConsumerState<StudentDashboardView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authUserChangesProvider);

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Error: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('User not found.')));
        }

        final pages = _buildPages(user);
        final titles = [
          'My Papers',
          'Submit Paper',
          'Discover',
          'Connections',
          'Discussions',
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            final body = Scaffold(
              appBar: AppBar(
                title: Text('Student · ${titles[_index]}'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[_index],
              ),
              bottomNavigationBar: isWide
                  ? null
                  : NavigationBar(
                      selectedIndex: _index,
                      destinations: const [
                        NavigationDestination(icon: Icon(Icons.library_books_outlined), label: 'My Papers'),
                        NavigationDestination(icon: Icon(Icons.note_add_outlined), label: 'Submit'),
                        NavigationDestination(icon: Icon(Icons.travel_explore_outlined), label: 'Discover'),
                        NavigationDestination(icon: Icon(Icons.people_outline), label: 'Connections'),
                        NavigationDestination(icon: Icon(Icons.forum_outlined), label: 'Discuss'),
                      ],
                      onDestinationSelected: (value) => setState(() => _index = value),
                    ),
            );

            if (!isWide) {
              return body;
            }

            return Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: (value) => setState(() => _index = value),
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.library_books_outlined),
                        label: Text('My Papers'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.note_add_outlined),
                        label: Text('Submit'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.travel_explore_outlined),
                        label: Text('Discover'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.people_outline),
                        label: Text('Connections'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.forum_outlined),
                        label: Text('Discussions'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildPages(AppUser user) {
    return [
      StudentPapersOverviewView(user: user),
      StudentPaperSubmissionView(user: user),
      StudentDiscoverView(user: user),
      NetworkView(user: user),
      DiscussionsView(user: user),
    ];
  }
}
