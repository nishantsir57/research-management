import 'package:cloud_firestore/cloud_firestore.dart';

class PaperComment {
  PaperComment({
    required this.id,
    required this.paperId,
    required this.authorId,
    required this.commentText,
    required this.createdAt,
  });

  final String id;
  final String paperId;
  final String authorId;
  final String commentText;
  final DateTime createdAt;

  factory PaperComment.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PaperComment(
      id: doc.id,
      paperId: data['paperId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      commentText: data['commentText'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paperId': paperId,
      'authorId': authorId,
      'commentText': commentText,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
