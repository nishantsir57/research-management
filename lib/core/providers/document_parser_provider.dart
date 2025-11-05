import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/document_parser_service.dart';

final documentParserProvider = Provider<DocumentParserService>((ref) {
  return DocumentParserService();
});
