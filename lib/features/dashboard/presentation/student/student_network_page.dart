import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/connection.dart';
import '../../../auth/providers/auth_controller.dart';
import '../../../common/providers/user_directory_provider.dart';
import '../../../networking/providers/connection_providers.dart';

class StudentNetworkPage extends ConsumerWidget {
  const StudentNetworkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDirectoryAsync = ref.watch(userDirectoryProvider);
    final connectionsAsync = ref.watch(connectionRequestsProvider);
    final currentUser = ref.watch(currentAppUserProvider);

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
          connectionsAsync.when(
            data: (connections) => userDirectoryAsync.when(
              data: (users) {
                final filtered = users.where((user) => user.id != currentUser?.id).toList();
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filtered
                      .map(
                        (user) => _UserCard(
                          user: user,
                          connection: _findConnection(connections, currentUser?.id ?? '', user.id),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Unable to load network: $error'),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Unable to load connections: $error'),
          ),
        ],
      ),
    );
  }

  ConnectionRequest? _findConnection(
    List<ConnectionRequest> connections,
    String currentUserId,
    String otherUserId,
  ) {
    try {
      return connections.firstWhere(
        (connection) =>
            (connection.requesterId == currentUserId && connection.recipientId == otherUserId) ||
            (connection.requesterId == otherUserId && connection.recipientId == currentUserId),
      );
    } catch (_) {
      return null;
    }
  }
}

class _UserCard extends ConsumerWidget {
  const _UserCard({required this.user, required this.connection});

  final AppUser user;
  final ConnectionRequest? connection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentAppUserProvider);
    final isPending = connection?.status == ConnectionStatus.pending;
    final isAccepted = connection?.status == ConnectionStatus.accepted;
    final isIncoming =
        connection != null && connection!.recipientId == currentUser?.id && isPending;

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
              backgroundColor: AppColors.success.withOpacity(0.2),
              labelStyle:
                  const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600),
            )
          else if (isIncoming)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ref
                        .read(connectionControllerProvider)
                        .respond(connection!.id, ConnectionStatus.accepted),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => ref
                      .read(connectionControllerProvider)
                      .respond(connection!.id, ConnectionStatus.rejected),
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
              onPressed: () =>
                  ref.read(connectionControllerProvider).sendRequest(user.id),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}
