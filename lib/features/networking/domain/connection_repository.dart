import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/connection.dart';

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ConnectionRepository(firestore: firestore);
});

class ConnectionRepository {
  ConnectionRepository({required FirebaseFirestore firestore})
      : _firestore = firestore,
        _uuid = const Uuid();

  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  static const _collection = 'connectionRequests';

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection(_collection);

  Stream<List<ConnectionRequest>> watchConnections(String userId) {
    return _requests
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ConnectionRequest.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  Future<void> sendRequest({
    required String requesterId,
    required String recipientId,
  }) async {
    final existing = await _requests
        .where('participants', arrayContains: requesterId)
        .where('participants', arrayContains: recipientId)
        .get();
    if (existing.docs.isNotEmpty) return;

    final doc = _requests.doc(_uuid.v4());
    await doc.set({
      'requesterId': requesterId,
      'recipientId': recipientId,
      'participants': [requesterId, recipientId],
      'status': ConnectionStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> respondToRequest({
    required String requestId,
    required ConnectionStatus status,
  }) async {
    await _requests.doc(requestId).update({
      'status': status.name,
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }
}
