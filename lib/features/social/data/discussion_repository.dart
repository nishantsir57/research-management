import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/discussion.dart';
import '../../../core/models/discussion_message.dart';

class DiscussionRepository {
  DiscussionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const discussionsCollection = 'discussions';
  static const messagesCollection = 'discussionMessages';

  Stream<List<Discussion>> watchDiscussions() {
    return _firestore
        .collection(discussionsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(Discussion.fromDocument).toList(),
        );
  }

  Stream<List<DiscussionMessage>> watchMessages(String discussionId) {
    return _firestore
        .collection(messagesCollection)
        .where('discussionId', isEqualTo: discussionId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(DiscussionMessage.fromDocument).toList(),
        );
  }

  Future<String> createDiscussion({
    required String title,
    required String createdBy,
  }) async {
    final doc = await _firestore.collection(discussionsCollection).add({
      'title': title,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> postMessage({
    required String discussionId,
    required String text,
    required String createdBy,
  }) async {
    await _firestore.collection(messagesCollection).add({
      'discussionId': discussionId,
      'text': text,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
