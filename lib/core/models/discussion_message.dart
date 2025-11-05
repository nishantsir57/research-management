import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionMessage {
  DiscussionMessage({
    required this.id,
    required this.discussionId,
    required this.text,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String discussionId;
  final String text;
  final String createdBy;
  final DateTime createdAt;

  factory DiscussionMessage.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return DiscussionMessage(
      id: doc.id,
      discussionId: data['discussionId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discussionId': discussionId,
      'text': text,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
