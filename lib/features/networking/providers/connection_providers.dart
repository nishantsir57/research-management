import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/connection.dart';
import '../../auth/providers/auth_controller.dart';
import '../domain/connection_repository.dart';

final connectionRequestsProvider = StreamProvider<List<ConnectionRequest>>((ref) {
  final user = ref.watch(currentAppUserProvider);
  final repository = ref.watch(connectionRepositoryProvider);
  if (user == null) return const Stream.empty();
  return repository.watchConnections(user.id);
});

final connectionControllerProvider =
    Provider<ConnectionController>((ref) => ConnectionController(ref: ref));

class ConnectionController {
  ConnectionController({required this.ref});

  final Ref ref;

  ConnectionRepository get _repository => ref.read(connectionRepositoryProvider);

  Future<void> sendRequest(String recipientId) async {
    final user = ref.read(currentAppUserProvider);
    if (user == null) throw StateError('Not authenticated');
    await _repository.sendRequest(requesterId: user.id, recipientId: recipientId);
  }

  Future<void> respond(String requestId, ConnectionStatus status) async {
    await _repository.respondToRequest(requestId: requestId, status: status);
  }
}
