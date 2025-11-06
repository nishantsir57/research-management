import 'package:flutter/material.dart';

import '../../common/widgets/role_scaffold.dart';
import '../../common/widgets/user_avatar_button.dart';

const reviewerNavItems = [
  RoleNavigationItem(icon: Icons.dashboard_customize_outlined, label: 'Dashboard', route: '/reviewer/home'),
  RoleNavigationItem(icon: Icons.task_outlined, label: 'Assigned Papers', route: '/reviewer/assigned'),
  RoleNavigationItem(icon: Icons.history_outlined, label: 'Reviewed', route: '/reviewer/history'),
  RoleNavigationItem(icon: Icons.forum_outlined, label: 'Discussions', route: '/reviewer/discussions'),
  RoleNavigationItem(icon: Icons.settings_outlined, label: 'Settings', route: '/reviewer/settings'),
];

class ReviewerShellPage extends StatelessWidget {
  const ReviewerShellPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      title: 'Reviewer Workspace',
      navItems: reviewerNavItems,
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
