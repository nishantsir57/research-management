import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/models/user_connection.dart';
import '../../../shared/domain/user_providers.dart';
import '../../domain/connection_providers.dart';

class NetworkView extends ConsumerWidget {
  const NetworkView({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionsAsync = ref.watch(userConnectionsProvider(user.uid));
    final studentsAsync = ref.watch(studentsStreamProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: connectionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Failed to load connections: $error')),
                data: (connections) => _ConnectionsList(user: user, connections: connections),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: studentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Failed to load community: $error')),
                data: (students) => _SuggestionsList(
                  currentUser: user,
                  connections: connectionsAsync.value ?? [],
                  students: students,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectionsList extends ConsumerWidget {
  const _ConnectionsList({required this.user, required this.connections});

  final AppUser user;
  final List<UserConnection> connections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (connections.isEmpty) {
      return const Center(child: Text('No connections yet. Discover peers and send a request.'));
    }

    return ListView.separated(
      itemCount: connections.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final connection = connections[index];
        final counterpartId = connection.userA == user.uid ? connection.userB : connection.userA;
        final isIncoming = connection.status == ConnectionStatus.pending && connection.userB == user.uid;
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text('User • $counterpartId'),
          subtitle: Text('Status: ${connection.status.name}'),
          trailing: isIncoming
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => ref
                          .read(connectionRepositoryProvider)
                          .deleteConnection(connection.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => ref
                          .read(connectionRepositoryProvider)
                          .updateConnectionStatus(connectionId: connection.id, status: ConnectionStatus.connected),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}

class _SuggestionsList extends ConsumerWidget {
  const _SuggestionsList({
    required this.currentUser,
    required this.students,
    required this.connections,
  });

  final AppUser currentUser;
  final List<AppUser> students;
  final List<UserConnection> connections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectedIds = connections
        .map((connection) => connection.userA == currentUser.uid ? connection.userB : connection.userA)
        .toSet()
      ..add(currentUser.uid);

    final pendingIds = connections
        .where((connection) => connection.status == ConnectionStatus.pending)
        .map((connection) => connection.userA == currentUser.uid ? connection.userB : connection.userA)
        .toSet();

    final suggestions = students.where((student) => !connectedIds.contains(student.uid)).toList();

    if (suggestions.isEmpty) {
      return const Center(child: Text('Everyone in your network is already connected.'));
    }

    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final student = suggestions[index];
        final isPending = pendingIds.contains(student.uid);
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.school_outlined)),
          title: Text(student.fullName),
          subtitle: Text(student.department ?? 'No department'),
          trailing: isPending
              ? const Text('Pending', style: TextStyle(color: Colors.orange))
              : TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(connectionRepositoryProvider).sendConnectionRequest(
                          currentUserId: currentUser.uid,
                          targetUserId: student.uid,
                        );
                    messenger.showSnackBar(
                      SnackBar(content: Text('Request sent to ${student.fullName}.')),
                    );
                  },
                  child: const Text('Connect'),
                ),
        );
      },
    );
  }
}
