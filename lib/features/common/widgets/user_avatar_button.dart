import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/app_user.dart';
import '../../auth/domain/auth_role.dart';
import '../../auth/controllers/auth_controller.dart';

class UserAvatarButton extends StatelessWidget {
  const UserAvatarButton({super.key});

  AuthController get _authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final AppUser? user = _authController.currentUser.value;
      if (user == null) {
        return const SizedBox.shrink();
      }
      final initials = _initials(user.displayName);
      return PopupMenuButton<_MenuAction>(
        onSelected: (value) async {
          switch (value) {
            case _MenuAction.profile:
              final route = switch (user.role) {
                AuthRole.student => AppRoutes.student,
                AuthRole.reviewer => AppRoutes.reviewer,
                AuthRole.admin => AppRoutes.admin,
              };
              Get.toNamed('$route/settings');
              break;
            case _MenuAction.signOut:
              await _authController.signOut();
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _MenuAction.profile,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(user.displayName),
              subtitle: Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray500),
              ),
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: _MenuAction.profile,
            child: Text('View profile'),
          ),
          const PopupMenuItem(
            value: _MenuAction.signOut,
            child: Text('Sign out'),
          ),
        ],
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.indigo600,
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      final word = parts.first;
      if (word.length >= 2) {
        return word.substring(0, 2).toUpperCase();
      }
      return word.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

enum _MenuAction { profile, signOut }
