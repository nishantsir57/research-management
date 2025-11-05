import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/connection_repository.dart';

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ConnectionRepository(firestore);
});

final userConnectionsProvider =
    StreamProvider.family((ref, String userId) {
  return ref.watch(connectionRepositoryProvider).watchConnections(userId);
});
