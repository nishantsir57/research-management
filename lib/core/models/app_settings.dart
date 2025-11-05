import 'package:cloud_firestore/cloud_firestore.dart';

class AppSettings {
  AppSettings({
    required this.aiReviewEnabled,
    required this.updatedAt,
  });

  final bool aiReviewEnabled;
  final DateTime updatedAt;

  factory AppSettings.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppSettings(
      aiReviewEnabled: data['aiReviewEnabled'] as bool? ?? true,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aiReviewEnabled': aiReviewEnabled,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
