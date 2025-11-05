import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/paper_comment.dart';

class PaperCommentRepository {
  PaperCommentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const collectionName = 'paperComments';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Stream<List<PaperComment>> watchComments(String paperId) {
    return _collection
        .where('paperId', isEqualTo: paperId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(PaperComment.fromDocument).toList());
  }

  Future<void> addComment(PaperComment comment) async {
    await _collection.add(comment.toMap());
  }
}
