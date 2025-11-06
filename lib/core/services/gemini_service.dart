import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../data/models/research_paper.dart';

class GeminiService {
  GeminiService({String? apiKey}) : apiKey = apiKey ?? const String.fromEnvironment('GEMINI_API_KEY');

  final String apiKey;
  static const String _defaultModel = 'gemini-1.5-flash';

  GenerativeModel? _model;

  bool get isConfigured => apiKey.isNotEmpty;

  GenerativeModel _ensureModel() {
    return _model ??= GenerativeModel(
      model: _defaultModel,
      apiKey: apiKey,
    );
  }

  Future<AiReviewResult> generatePreReview({
    required ResearchPaper paper,
    String? plainTextContent,
  }) async {
    if (!isConfigured) {
      throw StateError(
        'Gemini API key missing. Pass --dart-define=GEMINI_API_KEY=your_key when running.',
      );
    }

    final model = _ensureModel();
    final prompt = _buildPrompt(paper: paper, plainTextContent: plainTextContent);
    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';
    return _parseResponse(text, paperId: paper.id);
  }

  String _buildPrompt({
    required ResearchPaper paper,
    String? plainTextContent,
  }) {
    final buffer = StringBuffer()
      ..writeln('You are an academic research reviewer for ${paper.departmentId} department.')
      ..writeln('Paper title: ${paper.title}')
      ..writeln('Abstract: ${paper.abstractText}')
      ..writeln('Keywords: ${paper.keywords.join(', ')}')
      ..writeln('Please provide a structured review with: ')
      ..writeln('- Overall summary')
      ..writeln('- Strengths')
      ..writeln('- Areas of improvement')
      ..writeln('- Estimated quality score (0-100)')
      ..writeln('- Plagiarism risk percentage (0-100)')
      ..writeln()
      ..writeln('Full content:')
      ..writeln(plainTextContent ?? paper.content ?? 'Not provided.');
    return buffer.toString();
  }

  AiReviewResult _parseResponse(String text, {required String paperId}) {
    // Attempt to parse JSON first, fallback to heuristics.
    try {
      final map = jsonDecode(text) as Map<String, dynamic>;
      return AiReviewResult(
        modelId: _defaultModel,
        qualityScore: (map['qualityScore'] as num?)?.toDouble() ?? 0,
        plagiarismRisk: (map['plagiarismRisk'] as num?)?.toDouble() ?? 0,
        summary: map['summary'] as String? ?? '',
        strengths: (map['strengths'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(growable: false) ??
            const [],
        improvements: (map['improvements'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(growable: false) ??
            const [],
        createdAt: DateTime.now(),
      );
    } catch (_) {
      final lines = LineSplitter.split(text).toList();
      final summary = lines.take(8).join('\n');
      final strengths = lines
          .where((line) => line.toLowerCase().contains('strength'))
          .map((line) => line.replaceAll(RegExp(r'^[-*]\s*'), ''))
          .toList();
      final improvements = lines
          .where((line) => line.toLowerCase().contains('improve'))
          .map((line) => line.replaceAll(RegExp(r'^[-*]\s*'), ''))
          .toList();
      return AiReviewResult(
        modelId: _defaultModel,
        qualityScore: 0,
        plagiarismRisk: 0,
        summary: summary,
        strengths: strengths,
        improvements: improvements,
        createdAt: DateTime.now(),
      );
    }
  }
}
