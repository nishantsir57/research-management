import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_user.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../papers/presentation/views/student/student_discover_view.dart';
import '../../../papers/presentation/views/student/student_home_view.dart';
import '../../../papers/presentation/views/student/student_paper_submission_view.dart';
import '../../../papers/presentation/views/student/student_papers_overview_view.dart';
import '../../../social/presentation/views/discussions_view.dart';
import '../../../social/presentation/views/network_view.dart';
import '../../../shared/widgets/gradient_app_bar.dart';

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

        final navItems = _navItems();
        final pages = _buildPages(user);

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1024;

            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: GradientAppBar(
                userName: user.fullName,
                onLogout: () => ref.read(authRepositoryProvider).signOut(),
                onNotifications: () {},
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: isWide
                    ? Row(
                        children: [
                          _DesktopNav(
                            items: navItems,
                            selectedIndex: _index,
                            onChanged: (value) => setState(() => _index = value),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, bottom: 24),
                              child: pages[_index],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: pages[_index],
                      ),
              ),
              bottomNavigationBar: isWide
                  ? null
                  : NavigationBar(
                      selectedIndex: _index,
                      backgroundColor: Colors.white,
                      indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      destinations: navItems
                          .map(
                            (item) => NavigationDestination(
                              icon: Icon(item.icon),
                              label: item.label,
                            ),
                          )
                          .toList(),
                      onDestinationSelected: (value) => setState(() => _index = value),
                    ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildPages(AppUser user) {
    return [
      StudentHomeView(user: user, onSubmitPaper: () => setState(() => _index = 2)),
      StudentPapersOverviewView(user: user),
      StudentPaperSubmissionView(user: user),
      StudentDiscoverView(user: user),
      NetworkView(user: user),
      DiscussionsView(user: user),
    ];
  }

  List<_NavItem> _navItems() {
    return const [
      _NavItem(label: 'Home', icon: Icons.dashboard_customize_rounded),
      _NavItem(label: 'My Papers', icon: Icons.library_books_outlined),
      _NavItem(label: 'Submit', icon: Icons.note_add_outlined),
      _NavItem(label: 'Discover', icon: Icons.travel_explore_outlined),
      _NavItem(label: 'Network', icon: Icons.people_alt_outlined),
      _NavItem(label: 'Discuss', icon: Icons.forum_outlined),
    ];
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav({required this.items, required this.selectedIndex, required this.onChanged});

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 24),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 18)),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            for (var i = 0; i < items.length; i++)
              _NavButton(
                item: items[i],
                isSelected: i == selectedIndex,
                onTap: () => onChanged(i),
                theme: theme,
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.isSelected, required this.onTap, required this.theme});

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant;
    final decoration = isSelected
        ? BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4338CA), Color(0xFF2563EB), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x553138A6), blurRadius: 18, offset: Offset(0, 12)),
            ],
          )
        : BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: decoration,
          child: Row(
            children: [
              Icon(item.icon, color: foreground),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: theme.textTheme.labelLarge?.copyWith(color: foreground, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
