import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ai_review_service.dart';

const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

final aiReviewServiceProvider = Provider<AIReviewService?>((ref) {
  if (_geminiApiKey.isEmpty) {
    return null;
  }
  return AIReviewService(apiKey: _geminiApiKey);
});
