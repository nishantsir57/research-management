import 'package:flutter/material.dart';

import '../../common/widgets/role_scaffold.dart';
import '../../common/widgets/user_avatar_button.dart';

const studentNavItems = [
  RoleNavigationItem(icon: Icons.dashboard_outlined, label: 'Home', route: '/student/home'),
  RoleNavigationItem(icon: Icons.folder_copy_outlined, label: 'My Papers', route: '/student/papers'),
  RoleNavigationItem(icon: Icons.upload_file_outlined, label: 'Submit Paper', route: '/student/submit'),
  RoleNavigationItem(icon: Icons.forum_outlined, label: 'Discussions', route: '/student/discussions'),
  RoleNavigationItem(icon: Icons.trending_up_outlined, label: 'Trending', route: '/student/trending'),
  RoleNavigationItem(icon: Icons.workspace_premium_outlined, label: 'Achievements', route: '/student/achievements'),
  RoleNavigationItem(icon: Icons.people_alt_outlined, label: 'Network', route: '/student/network'),
  RoleNavigationItem(icon: Icons.settings_outlined, label: 'Settings', route: '/student/settings'),
];

class StudentShellPage extends StatelessWidget {
  const StudentShellPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      title: 'Student Workspace',
      navItems: studentNavItems,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: UserAvatarButton(),
        ),
      ],
      child: child,
    );
  }
}
