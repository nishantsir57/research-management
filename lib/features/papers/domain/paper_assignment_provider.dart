import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/domain/user_providers.dart';
import 'paper_providers.dart';
import 'paper_assignment_service.dart';

final paperAssignmentServiceProvider = Provider<PaperAssignmentService>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final paperRepository = ref.watch(researchPaperRepositoryProvider);
  return PaperAssignmentService(userRepository, paperRepository);
});
