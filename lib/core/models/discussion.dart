import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  Discussion({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String createdBy;
  final DateTime createdAt;

  factory Discussion.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Discussion(
      id: doc.id,
      title: data['title'] as String? ?? '',
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
