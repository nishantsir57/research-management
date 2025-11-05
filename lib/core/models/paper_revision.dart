import 'package:cloud_firestore/cloud_firestore.dart';

class PaperRevision {
  PaperRevision({
    required this.version,
    required this.note,
    required this.submittedAt,
  });

  final int version;
  final String note;
  final DateTime submittedAt;

  factory PaperRevision.fromMap(Map<String, dynamic> data) {
    return PaperRevision(
      version: data['version'] as int? ?? 1,
      note: data['note'] as String? ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'note': note,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}
