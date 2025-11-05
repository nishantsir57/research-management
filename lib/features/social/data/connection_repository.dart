import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/user_connection.dart';

class ConnectionRepository {
  ConnectionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const collectionName = 'connections';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Stream<List<UserConnection>> watchConnections(String userId) {
    return _collection
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(UserConnection.fromDocument).toList());
  }

  Future<void> sendConnectionRequest({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await _collection.add({
      'userA': currentUserId,
      'userB': targetUserId,
      'users': [currentUserId, targetUserId],
      'status': ConnectionStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateConnectionStatus({
    required String connectionId,
    required ConnectionStatus status,
  }) async {
    await _collection.doc(connectionId).update({'status': status.name});
  }

  Future<void> deleteConnection(String connectionId) async {
    await _collection.doc(connectionId).delete();
  }
}
