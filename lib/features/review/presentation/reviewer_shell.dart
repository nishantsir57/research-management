import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../common/widgets/user_avatar_button.dart';
import 'reviewer/reviewer_assigned_page.dart';
import 'reviewer/reviewer_dashboard_page.dart';
import 'reviewer/reviewer_discussions_page.dart';
import 'reviewer/reviewer_history_page.dart';
import 'reviewer/reviewer_settings_page.dart';

class ReviewerShellPage extends StatefulWidget {
  const ReviewerShellPage({super.key});

  @override
  State<ReviewerShellPage> createState() => _ReviewerShellPageState();
}

class _ReviewerShellPageState extends State<ReviewerShellPage> {
  int _currentIndex = 0;

  final _pages = const [
    ReviewerDashboardPage(),
    ReviewerAssignedPapersPage(),
    ReviewerHistoryPage(),
    ReviewerDiscussionsPage(),
    ReviewerSettingsPage(),
  ];

  final _navItems = const [
    _NavItem(Icons.dashboard_customize_outlined, 'Dashboard'),
    _NavItem(Icons.task_outlined, 'Assigned Papers'),
    _NavItem(Icons.history_outlined, 'Reviewed'),
    _NavItem(Icons.forum_outlined, 'Discussions'),
    _NavItem(Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        return Scaffold(
          backgroundColor: AppColors.pearl50,
          appBar: AppBar(
            title: const Text('Reviewer Workspace'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: UserAvatarButton(),
              ),
            ],
          ),
          drawer: isDesktop ? null : Drawer(child: _buildDrawerNav()),
          body: Row(
            children: [
              if (isDesktop) _buildSideNav(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _pages[_currentIndex],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.gray200)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        itemCount: _navItems.length,
        itemBuilder: (context, index) {
          final item = _navItems[index];
          final selected = index == _currentIndex;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => setState(() => _currentIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: selected ? AppColors.indigo700 : Colors.white,
                  border: Border.all(
                    color: selected ? AppColors.indigo600 : AppColors.gray200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item.icon, color: selected ? Colors.white : AppColors.gray600),
                    const SizedBox(width: 12),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerNav() {
    return SafeArea(
      child: ListView.builder(
        itemCount: _navItems.length,
        itemBuilder: (context, index) {
          final item = _navItems[index];
          final selected = index == _currentIndex;
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            selected: selected,
            onTap: () {
              Navigator.of(context).pop();
              setState(() => _currentIndex = index);
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _navItems
          .map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label))
          .toList(),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}
