import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/research_paper.dart';

class ResearchPaperRepository {
  ResearchPaperRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const collectionName = 'researchPapers';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Stream<List<ResearchPaper>> watchByAuthor(String authorId) {
    return _collection
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ResearchPaper.fromDocument(doc)).toList(),
        );
  }

  Stream<List<ResearchPaper>> watchAssignedToReviewer(String reviewerId) {
    return _collection
        .where('assignedReviewerId', isEqualTo: reviewerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ResearchPaper.fromDocument(doc)).toList(),
        );
  }

  Stream<ResearchPaper?> watchPaper(String paperId) {
    return _collection.doc(paperId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ResearchPaper.fromDocument(doc);
    });
  }

  Stream<List<ResearchPaper>> watchAllPapers() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(ResearchPaper.fromDocument).toList(),
        );
  }

  Future<ResearchPaper?> fetchPaper(String paperId) async {
    final doc = await _collection.doc(paperId).get();
    if (!doc.exists) return null;
    return ResearchPaper.fromDocument(doc);
  }

  Future<String> submitPaper(ResearchPaper paper) async {
    final docRef = await _collection.add({
      ...paper.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updatePaper(String paperId, Map<String, dynamic> data) async {
    await _collection.doc(paperId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> assignReviewer({
    required String paperId,
    required String reviewerId,
  }) async {
    await updatePaper(paperId, {
      'assignedReviewerId': reviewerId,
      'status': PaperStatus.underReview.name,
    });
  }

  Future<void> setAIReviewFeedback({
    required String paperId,
    required Map<String, dynamic> feedback,
  }) async {
    await updatePaper(paperId, {
      'aiFeedback': feedback,
      'status': PaperStatus.aiReview.name,
    });
  }

  Future<void> updatePaperStatus({
    required String paperId,
    required PaperStatus status,
    String? reviewerComments,
    List<Map<String, dynamic>>? highlights,
  }) async {
    await updatePaper(paperId, {
      'status': status.name,
      if (reviewerComments != null) 'reviewerComments': reviewerComments,
      if (highlights != null) 'reviewerHighlights': highlights,
    });
  }

  Future<void> resubmitPaper({
    required String paperId,
    String? contentText,
    String? fileUrl,
    Map<String, dynamic>? revisionEntry,
  }) async {
    final updateData = <String, dynamic>{
      'status': PaperStatus.submitted.name,
      'contentText': contentText,
      'fileUrl': fileUrl,
      'reviewerComments': null,
      'reviewerHighlights': <Map<String, dynamic>>[],
      'updatedAt': FieldValue.serverTimestamp(),
    };

    updateData.removeWhere((key, value) => value == null);

    if (revisionEntry != null) {
      updateData['studentResubmissions'] = FieldValue.arrayUnion([revisionEntry]);
    }

    await _collection.doc(paperId).update(updateData);
  }
}
