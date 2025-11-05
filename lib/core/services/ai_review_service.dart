import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/ai_review_feedback.dart';

class AIReviewService {
  AIReviewService({required String apiKey, String model = 'gemini-pro'})
      : _model = GenerativeModel(model: model, apiKey: apiKey);

  final GenerativeModel _model;

  Future<AIReviewFeedback> reviewPaper({required String content}) async {
    final prompt = Content.text(
      'You are assisting the ResearchHub platform to perform a pre-review of '
      'an academic article. Analyse the provided text and return a JSON object '
      'with keys: summary (string), suggestions (array of strings), '
      'unclearSections (array of strings), readabilityScore (number 0-100). '
      'Keep suggestions actionable and concise. Only provide valid JSON.',
    );

    final result = await _model.generateContent([prompt, Content.text(content)]);
    final responseText = result.text;

    if (responseText == null) {
      throw Exception('Gemini did not return any content.');
    }

    final cleanText = responseText.trim().replaceAll('```json', '').replaceAll('```', '');
    final decoded = jsonDecode(cleanText) as Map<String, dynamic>;

    return AIReviewFeedback(
      summary: decoded['summary'] as String? ?? '',
      suggestions: (decoded['suggestions'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          const [],
      unclearSections: (decoded['unclearSections'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          const [],
      readabilityScore: (decoded['readabilityScore'] is num)
          ? (decoded['readabilityScore'] as num).toDouble()
          : 0,
      generatedAt: DateTime.now(),
    );
  }
}
