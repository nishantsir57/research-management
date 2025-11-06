import 'package:flutter/material.dart';

import '../../common/widgets/role_scaffold.dart';
import '../../common/widgets/user_avatar_button.dart';

const adminNavItems = [
  RoleNavigationItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/admin/home'),
  RoleNavigationItem(icon: Icons.account_tree_outlined, label: 'Departments', route: '/admin/departments'),
  RoleNavigationItem(icon: Icons.people_outlined, label: 'Users', route: '/admin/users'),
  RoleNavigationItem(icon: Icons.article_outlined, label: 'All Papers', route: '/admin/papers'),
  RoleNavigationItem(icon: Icons.settings_outlined, label: 'System Settings', route: '/admin/settings'),
];

class AdminShellPage extends StatelessWidget {
  const AdminShellPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      title: 'Admin Control Center',
      navItems: adminNavItems,
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
