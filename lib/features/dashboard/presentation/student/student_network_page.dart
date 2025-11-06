import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/connection.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../common/controllers/user_directory_controller.dart';
import '../../../networking/controllers/connection_controller.dart';

class StudentNetworkPage extends StatelessWidget {
  const StudentNetworkPage({super.key});

  ConnectionController get _connectionController => Get.find<ConnectionController>();
  UserDirectoryController get _userDirectoryController => Get.find<UserDirectoryController>();
  AuthController get _authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = _authController.currentUser.value;
      if (currentUser == null) {
        return const Center(child: Text('Sign in to view the network.'));
      }

      final users =
          _userDirectoryController.users.where((user) => user.id != currentUser.id).toList();
      final requests = _connectionController.requests;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Research network', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Connect with other researchers to follow their publications and collaborate in discussions.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: users
                  .map(
                    (user) => _UserCard(
                      user: user,
                      request: requests.firstWhereOrNull(
                        (request) =>
                            (request.requesterId == currentUser.id &&
                                request.recipientId == user.id) ||
                            (request.requesterId == user.id &&
                                request.recipientId == currentUser.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, this.request});

  final AppUser user;
  final ConnectionRequest? request;

  ConnectionController get _connectionController => Get.find<ConnectionController>();
  AuthController get _authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final currentUser = _authController.currentUser.value!;
    final isPending = request?.status == ConnectionStatus.pending;
    final isAccepted = request?.status == ConnectionStatus.accepted;
    final isIncoming =
        request != null && request!.recipientId == currentUser.id && isPending;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.indigo600,
                child: Text(
                  user.displayName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      user.role.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.bio ?? 'No bio provided.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          if (isAccepted)
            Chip(
              avatar: const Icon(Icons.link_outlined, size: 18),
              label: const Text('Connected'),
              backgroundColor: AppColors.success.withValues(alpha: 0.2),
              labelStyle:
                  const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600),
            )
          else if (isIncoming)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _connectionController.respond(request!.id, ConnectionStatus.accepted),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () =>
                      _connectionController.respond(request!.id, ConnectionStatus.rejected),
                  icon: const Icon(Icons.close),
                ),
              ],
            )
          else if (isPending)
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.hourglass_empty_outlined),
              label: const Text('Request pending'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _connectionController.sendRequest(user.id),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}
