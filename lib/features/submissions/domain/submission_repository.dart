import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/utils/converters.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/paper_comment.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/domain/auth_role.dart';

class SubmissionRepository {
  SubmissionRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    GeminiService? geminiService,
  })  : _firestore = firestore ?? FirebaseService.firestore,
        _storage = storage ?? FirebaseService.storage,
        _geminiService = geminiService ?? GeminiService();

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final GeminiService _geminiService;

  static const _papersCollection = 'papers';
  static const _commentsCollection = 'comments';
  static const double _minQualityScore = 60;
  static const double _maxPlagiarismRisk = 30;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _papers =>
      _firestore.collection(_papersCollection);

  Future<AppSettings> _fetchSettings() async {
    final snapshot = await _firestore.collection('settings').doc('app').get();
    if (!snapshot.exists) {
      return const AppSettings(id: 'app');
    }
    return AppSettings.fromJson({
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  }

  Stream<List<ResearchPaper>> watchStudentPapers(String studentId) {
    return _papers
        .where('ownerId', isEqualTo: studentId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map(_mapSnapshot);
  }

  Stream<List<ResearchPaper>> watchAllPapers() {
    return _papers.orderBy('submittedAt', descending: true).snapshots().map(_mapSnapshot);
  }

  Stream<List<ResearchPaper>> watchPublishedPapers({
    String? departmentId,
    String? subjectId,
    PaperVisibility? visibility,
    DateTime? afterDate,
  }) {
    Query<Map<String, dynamic>> query = _papers.where('status', isEqualTo: PaperStatus.published.name);
    if (departmentId != null) {
      query = query.where('departmentId', isEqualTo: departmentId);
    }
    if (subjectId != null) {
      query = query.where('subjectId', isEqualTo: subjectId);
    }
    if (visibility != null) {
      query = query.where('visibility', isEqualTo: visibility.name);
    }
    if (afterDate != null) {
      query = query.where('publishedAt', isGreaterThan: afterDate);
    }
    return query.orderBy('publishedAt', descending: true).snapshots().map(_mapSnapshot);
  }

  Stream<List<ResearchPaper>> watchReviewerAssignments(String reviewerId) {
    return _papers
        .where('reviewerIds', arrayContains: reviewerId)
        .where('status', whereIn: [
          PaperStatus.submitted.name,
          PaperStatus.underReview.name,
          PaperStatus.aiReview.name,
          PaperStatus.revisionsRequested.name,
        ])
        .snapshots()
        .map(_mapSnapshot);
  }

  Stream<List<ResearchPaper>> watchReviewerHistory(String reviewerId) {
    return _papers
        .where('reviewerIds', arrayContains: reviewerId)
        .where('status', whereIn: [
          PaperStatus.approved.name,
          PaperStatus.published.name,
          PaperStatus.rejected.name,
        ])
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(_mapSnapshot);
  }

  Stream<ResearchPaper?> watchPaperById(String paperId) {
    return _papers.doc(paperId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return _paperFromDoc(snapshot);
    });
  }

  Stream<List<PaperComment>> watchPaperComments(String paperId) {
    return _papers
        .doc(paperId)
        .collection(_commentsCollection)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return PaperComment.fromJson({
                ...data,
                'id': doc.id,
              });
            }).toList());
  }

  Future<ResearchPaper> submitPaper({
    required AppUser student,
    required String title,
    required String abstractText,
    String? content,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
    required PaperFormat format,
    required PaperVisibility visibility,
    required String departmentId,
    required String subjectId,
    List<String>? tags,
    List<String>? keywords,
  }) async {
    final docRef = _papers.doc();
    String? fileUrl;
    String? storagePath;
    String? plainTextContent = content;

    if (file != null || fileBytes != null) {
      final resolvedName = fileName ??
          (file != null
              ? file.uri.pathSegments.last
              : 'paper_${DateTime.now().millisecondsSinceEpoch}.dat');
      final path = 'papers/${student.id}/${docRef.id}/$resolvedName';
      UploadTask uploadTask;
      if (fileBytes != null || kIsWeb) {
        final bytes = fileBytes ?? await file!.readAsBytes();
        uploadTask = _storage.ref(path).putData(bytes);
      } else {
        uploadTask = _storage.ref(path).putFile(file!);
      }
      final snapshot = await uploadTask;
      fileUrl = await snapshot.ref.getDownloadURL();
      storagePath = path;
    }

    final now = DateTime.now();

    final paper = ResearchPaper(
      id: docRef.id,
      title: title,
      ownerId: student.id,
      primaryReviewerId: null,
      reviewerIds: const [],
      abstractText: abstractText,
      content: plainTextContent,
      fileUrl: fileUrl,
      storagePath: storagePath,
      format: format,
      visibility: visibility,
      status: PaperStatus.aiReview,
      departmentId: departmentId,
      subjectId: subjectId,
      tags: tags ?? const [],
      keywords: keywords ?? const [],
      submittedAt: now,
      updatedAt: now,
    );

    await docRef.set(_paperToJson(paper));

    return _handleAiAndAssignment(
      docRef: docRef,
      paper: paper,
      plainTextContent: plainTextContent,
    );
  }

  Future<ResearchPaper> resubmitPaper({
    required ResearchPaper paper,
    String? updatedContent,
    File? newFile,
    Uint8List? newFileBytes,
    String? newFileName,
  }) async {
    String? fileUrl = paper.fileUrl;
    String? storagePath = paper.storagePath;
    if (newFile != null || newFileBytes != null) {
      final resolvedName = newFileName ??
          (newFile != null
              ? newFile.uri.pathSegments.last
              : 'paper_${DateTime.now().millisecondsSinceEpoch}.dat');
      final path = 'papers/${paper.ownerId}/${paper.id}/$resolvedName';
      UploadTask uploadTask;
      if (newFileBytes != null || kIsWeb) {
        final bytes = newFileBytes ?? await newFile!.readAsBytes();
        uploadTask = _storage.ref(path).putData(bytes);
      } else {
        uploadTask = _storage.ref(path).putFile(newFile!);
      }
      final snapshot = await uploadTask;
      fileUrl = await snapshot.ref.getDownloadURL();
      storagePath = path;
    }

    final docRef = _papers.doc(paper.id);
    final updatedPaper = paper.copyWith(
      content: updatedContent ?? paper.content,
      fileUrl: fileUrl,
      storagePath: storagePath,
      status: PaperStatus.aiReview,
      aiReview: null,
      updatedAt: DateTime.now(),
    );

    await docRef.update({
      if (updatedContent != null) 'content': updatedContent,
      'fileUrl': fileUrl,
      'storagePath': storagePath,
      'status': PaperStatus.aiReview.name,
      'aiReview': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return _handleAiAndAssignment(
      docRef: docRef,
      paper: updatedPaper,
      plainTextContent: updatedContent?.trim().isNotEmpty == true
          ? updatedContent
          : updatedPaper.content,
    );
  }

  Future<ResearchPaper> _handleAiAndAssignment({
    required DocumentReference<Map<String, dynamic>> docRef,
    required ResearchPaper paper,
    String? plainTextContent,
    AppSettings? settings,
  }) async {
    final appSettings = settings ?? await _fetchSettings();
    final aiEnabled = appSettings.aiPreReviewEnabled && _geminiService.isConfigured;

    if (aiEnabled) {
      try {
        final review = await _geminiService.generatePreReview(
          paper: paper,
          plainTextContent: plainTextContent,
        );
        if (_aiReviewPassed(review)) {
          return _assignReviewerForDoc(
            docRef: docRef,
            paper: paper,
            extraUpdates: {
              'aiReview': _aiReviewToJson(review),
            },
            statusWhenAssigned: PaperStatus.underReview,
            statusWhenUnassigned: PaperStatus.submitted,
          );
        }

        await docRef.update({
          'aiReview': _aiReviewToJson(review),
          'status': PaperStatus.revisionsRequested.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        final snapshot = await docRef.get();
        return _paperFromDoc(snapshot);
      } catch (error, stackTrace) {
        debugPrint('AI review error: $error\n$stackTrace');
        // fall through to reviewer assignment without AI
      }
    }

    return _assignReviewerForDoc(
      docRef: docRef,
      paper: paper,
      statusWhenAssigned: PaperStatus.underReview,
      statusWhenUnassigned: PaperStatus.submitted,
    );
  }

  Future<ResearchPaper> _assignReviewerForDoc({
    required DocumentReference<Map<String, dynamic>> docRef,
    required ResearchPaper paper,
    Map<String, dynamic>? extraUpdates,
    PaperStatus statusWhenAssigned = PaperStatus.underReview,
    PaperStatus statusWhenUnassigned = PaperStatus.submitted,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
      if (extraUpdates != null) ...extraUpdates,
    };

    String? reviewerId = paper.primaryReviewerId;
    if (reviewerId == null || reviewerId.isEmpty) {
      reviewerId = await _assignReviewer(departmentId: paper.departmentId);
    }

    if (reviewerId != null) {
      updates['primaryReviewerId'] = reviewerId;
      updates['reviewerIds'] = FieldValue.arrayUnion([reviewerId]);
      updates['status'] = statusWhenAssigned.name;
    } else {
      updates['status'] = statusWhenUnassigned.name;
    }

    await docRef.update(updates);
    final snapshot = await docRef.get();
    return _paperFromDoc(snapshot);
  }

  bool _aiReviewPassed(AiReviewResult review) {
    return review.qualityScore >= _minQualityScore &&
        review.plagiarismRisk <= _maxPlagiarismRisk;
  }

  Future<void> ensureStudentPipeline(String studentId) async {
    final pendingSnapshot = await _papers
        .where('ownerId', isEqualTo: studentId)
        .where('status', whereIn: [
          PaperStatus.aiReview.name,
          PaperStatus.submitted.name,
        ])
        .get();
    if (pendingSnapshot.docs.isEmpty) return;

    final settings = await _fetchSettings();

    for (final doc in pendingSnapshot.docs) {
      final paper = _paperFromDoc(doc);
      final docRef = doc.reference;

      if (paper.status == PaperStatus.aiReview && paper.aiReview == null) {
        await _handleAiAndAssignment(
          docRef: docRef,
          paper: paper,
          plainTextContent: paper.content,
          settings: settings,
        );
      } else if (paper.status == PaperStatus.submitted &&
          (paper.primaryReviewerId == null || paper.primaryReviewerId!.isEmpty)) {
        await _assignReviewerForDoc(
          docRef: docRef,
          paper: paper,
          statusWhenAssigned: PaperStatus.underReview,
          statusWhenUnassigned: PaperStatus.submitted,
        );
      }
    }
  }

  Future<void> updatePaperVisibility({
    required String paperId,
    required PaperVisibility visibility,
  }) async {
    await _papers.doc(paperId).update({
      'visibility': visibility.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addPaperComment({
    required String paperId,
    required String authorId,
    required String content,
    bool reviewerOnly = false,
  }) async {
    final commentId = _uuid.v4();
    await _papers.doc(paperId).collection(_commentsCollection).doc(commentId).set({
      'paperId': paperId,
      'authorId': authorId,
      'content': content,
      'isReviewerOnly': reviewerOnly,
      'likedBy': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleCommentLike({
    required String paperId,
    required String commentId,
    required String userId,
    required bool like,
  }) async {
    final doc = _papers.doc(paperId).collection(_commentsCollection).doc(commentId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (!snapshot.exists) return;
      final likedBy = List<String>.from(snapshot.data()!['likedBy'] ?? <String>[]);
      if (like) {
        if (!likedBy.contains(userId)) likedBy.add(userId);
      } else {
        likedBy.remove(userId);
      }
      transaction.update(doc, {'likedBy': likedBy});
    });
  }

  Future<void> recordReviewDecision({
    required ResearchPaper paper,
    required String reviewerId,
    required ReviewDecision decision,
    required String summary,
    List<String>? improvementPoints,
    List<HighlightAnnotation>? highlights,
  }) async {
    final feedback = ReviewFeedback(
      id: _uuid.v4(),
      reviewerId: reviewerId,
      decision: decision,
      summary: summary,
      improvementPoints: improvementPoints ?? const [],
      highlights: highlights ?? const [],
      createdAt: DateTime.now(),
    );

    final newStatus = _nextStatusFromDecision(decision);
    await _papers.doc(paper.id).update({
      'reviews': FieldValue.arrayUnion([_reviewToJson(feedback)]),
      'status': newStatus.name,
      'updatedAt': FieldValue.serverTimestamp(),
      if (newStatus == PaperStatus.published) 'publishedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> reassignReviewer({
    required String paperId,
    required String reviewerId,
    bool setAsPrimary = true,
  }) async {
    await _papers.doc(paperId).update({
      if (setAsPrimary) 'primaryReviewerId': reviewerId,
      'reviewerIds': FieldValue.arrayUnion([reviewerId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  PaperStatus _nextStatusFromDecision(ReviewDecision decision) {
    switch (decision) {
      case ReviewDecision.approve:
        return PaperStatus.approved;
      case ReviewDecision.requestChanges:
        return PaperStatus.revisionsRequested;
      case ReviewDecision.reject:
        return PaperStatus.rejected;
    }
  }

  List<ResearchPaper> _mapSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) => _paperFromDoc(doc)).toList();
  }

  ResearchPaper _paperFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ResearchPaper.fromJson({
      ...data,
      'id': doc.id,
      'format': data['format'],
      'visibility': data['visibility'],
      'status': data['status'],
      'reviews': (data['reviews'] as List<dynamic>? ?? [])
          .map((raw) => raw as Map<String, dynamic>)
          .toList(),
      'aiReview': data['aiReview'],
    });
  }

  Future<String?> _assignReviewer({required String departmentId}) async {
    final reviewers = await _firestore
        .collection('users')
        .where('role', isEqualTo: AuthRole.reviewer.name)
        .where('isReviewerApproved', isEqualTo: true)
        .where('isBlocked', isEqualTo: false)
        .where('departmentId', isEqualTo: departmentId)
        .limit(50)
        .get();
    if (reviewers.docs.isEmpty) return null;
    reviewers.docs.shuffle();
    return reviewers.docs.first.id;
  }

  Map<String, dynamic> _paperToJson(ResearchPaper paper) {
    return {
      'title': paper.title,
      'ownerId': paper.ownerId,
      'primaryReviewerId': paper.primaryReviewerId,
      'reviewerIds': paper.reviewerIds,
      'abstractText': paper.abstractText,
      'content': paper.content,
      'fileUrl': paper.fileUrl,
      'storagePath': paper.storagePath,
      'format': paper.format.name,
      'visibility': paper.visibility.name,
      'status': paper.status.name,
      'departmentId': paper.departmentId,
      'subjectId': paper.subjectId,
      'tags': paper.tags,
      'keywords': paper.keywords,
      'references': paper.references,
      'coAuthors': paper.coAuthors,
      'reviews': paper.reviews.map(_reviewToJson).toList(),
      'aiReview': paper.aiReview != null ? _aiReviewToJson(paper.aiReview!) : null,
      'submittedAt': const TimestampDateTimeConverter().toJson(paper.submittedAt),
      'updatedAt': const TimestampDateTimeConverter().toJson(paper.updatedAt),
      'publishedAt': const TimestampDateTimeConverter().toJson(paper.publishedAt),
    };
  }

  Map<String, dynamic> _reviewToJson(ReviewFeedback review) {
    return {
      'id': review.id,
      'reviewerId': review.reviewerId,
      'decision': review.decision.name,
      'summary': review.summary,
      'improvementPoints': review.improvementPoints,
      'highlights': review.highlights
          .map(
            (highlight) => {
              'id': highlight.id,
              'reviewerId': highlight.reviewerId,
              'startOffset': highlight.startOffset,
              'endOffset': highlight.endOffset,
              'colorHex': highlight.colorHex,
              'note': highlight.note,
              'createdAt': const TimestampDateTimeConverter().toJson(highlight.createdAt),
            },
          )
          .toList(),
      'createdAt': const TimestampDateTimeConverter().toJson(review.createdAt),
    };
  }

  Map<String, dynamic> _aiReviewToJson(AiReviewResult review) {
    return {
      'modelId': review.modelId,
      'qualityScore': review.qualityScore,
      'plagiarismRisk': review.plagiarismRisk,
      'summary': review.summary,
      'strengths': review.strengths,
      'improvements': review.improvements,
      'createdAt': const TimestampDateTimeConverter().toJson(review.createdAt),
    };
  }
}
