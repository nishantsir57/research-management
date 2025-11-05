import 'package:cloud_firestore/cloud_firestore.dart';

class AIReviewFeedback {
  AIReviewFeedback({
    required this.summary,
    required this.suggestions,
    required this.unclearSections,
    required this.readabilityScore,
    required this.generatedAt,
  });

  final String summary;
  final List<String> suggestions;
  final List<String> unclearSections;
  final double readabilityScore;
  final DateTime generatedAt;

  factory AIReviewFeedback.fromMap(Map<String, dynamic> data) {
    return AIReviewFeedback(
      summary: data['summary'] as String? ?? '',
      suggestions: (data['suggestions'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          const [],
      unclearSections: (data['unclearSections'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          const [],
      readabilityScore:
          (data['readabilityScore'] is num) ? (data['readabilityScore'] as num).toDouble() : 0,
      generatedAt: (data['generatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'suggestions': suggestions,
      'unclearSections': unclearSections,
      'readabilityScore': readabilityScore,
      'generatedAt': Timestamp.fromDate(generatedAt),
    };
  }
}
