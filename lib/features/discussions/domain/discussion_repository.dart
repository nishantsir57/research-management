import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/discussion.dart';

class DiscussionRepository {
  DiscussionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.firestore,
        _uuid = const Uuid();

  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  static const _threadsCollection = 'discussionThreads';
  static const _commentsCollection = 'comments';

  CollectionReference<Map<String, dynamic>> get _threads =>
      _firestore.collection(_threadsCollection);

  Stream<List<DiscussionThread>> watchThreads() {
    return _threads.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => DiscussionThread.fromJson({
              ...doc.data(),
              'id': doc.id,
            }),
          )
          .toList();
    });
  }

  Stream<List<DiscussionComment>> watchThreadComments(String threadId) {
    return _threads
        .doc(threadId)
        .collection(_commentsCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => DiscussionComment.fromJson({
                ...doc.data(),
                'id': doc.id,
              }),
            )
            .toList());
  }

  Future<void> createThread({
    required String creatorId,
    required String title,
    required String description,
    List<String>? tags,
    String? departmentId,
    String? subjectId,
  }) async {
    final doc = _threads.doc();
    await doc.set({
      'title': title,
      'createdBy': creatorId,
      'description': description,
      'tags': tags ?? <String>[],
      'departmentId': departmentId,
      'subjectId': subjectId,
      'isOpen': true,
      'participantCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addComment({
    required String threadId,
    required String authorId,
    required String content,
  }) async {
    final doc = _threads.doc(threadId).collection(_commentsCollection).doc(_uuid.v4());
    await doc.set({
      'threadId': threadId,
      'authorId': authorId,
      'content': content,
      'upvotes': <String>[],
      'replies': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _threads.doc(threadId).update({
      'participantCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleUpvote({
    required String threadId,
    required String commentId,
    required String userId,
    required bool upvote,
  }) async {
    final doc = _threads.doc(threadId).collection(_commentsCollection).doc(commentId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (!snapshot.exists) return;
      final current = List<String>.from(snapshot.data()!['upvotes'] ?? <String>[]);
      if (upvote) {
        if (!current.contains(userId)) current.add(userId);
      } else {
        current.remove(userId);
      }
      transaction.update(doc, {'upvotes': current});
    });
  }
}
