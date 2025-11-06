import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../common/widgets/user_avatar_button.dart';
import 'student/student_achievements_page.dart';
import 'student/student_discussions_page.dart';
import 'student/student_home_page.dart';
import 'student/student_network_page.dart';
import 'student/student_papers_page.dart';
import 'student/student_settings_page.dart';
import 'student/student_submit_page.dart';
import 'student/student_trending_page.dart';

class StudentShellPage extends StatefulWidget {
  const StudentShellPage({super.key});

  @override
  State<StudentShellPage> createState() => _StudentShellPageState();
}

class _StudentShellPageState extends State<StudentShellPage> {
  int _currentIndex = 0;

  final _pages = const [
    StudentHomePage(),
    StudentMyPapersPage(),
    StudentSubmitPaperPage(),
    StudentDiscussionsPage(),
    StudentTrendingPage(),
    StudentAchievementsPage(),
    StudentNetworkPage(),
    StudentSettingsPage(),
  ];

  final _navItems = const [
    _NavItem(Icons.dashboard_outlined, 'Home'),
    _NavItem(Icons.folder_copy_outlined, 'My Papers'),
    _NavItem(Icons.upload_file_outlined, 'Submit'),
    _NavItem(Icons.forum_outlined, 'Discussions'),
    _NavItem(Icons.trending_up_outlined, 'Trending'),
    _NavItem(Icons.workspace_premium_outlined, 'Achievements'),
    _NavItem(Icons.people_alt_outlined, 'Network'),
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
            title: const Text('Student Workspace'),
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
          bottomNavigationBar:
              isDesktop ? null : _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.gray200),
        ),
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
                    Icon(
                      item.icon,
                      color: selected ? Colors.white : AppColors.gray600,
                    ),
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
        padding: const EdgeInsets.all(16),
        itemCount: _navItems.length,
        itemBuilder: (context, index) {
          final item = _navItems[index];
          final selected = index == _currentIndex;
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            selected: selected,
            onTap: () {
              Get.back();
              setState(() => _currentIndex = index);
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _navItems
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}
