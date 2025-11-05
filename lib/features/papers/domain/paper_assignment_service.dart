import 'dart:math';

import '../../../core/models/research_paper.dart';
import '../../shared/data/user_repository.dart';
import '../data/research_paper_repository.dart';

class PaperAssignmentService {
  PaperAssignmentService(
    this._userRepository,
    this._paperRepository,
  );

  final UserRepository _userRepository;
  final ResearchPaperRepository _paperRepository;
  final _random = Random();

  Future<String?> assignReviewer(ResearchPaper paper) async {
    final departmentReviewers =
        await _userRepository.fetchReviewersForDepartment(paper.department);
    var candidates = departmentReviewers;

    if (candidates.isEmpty) {
      final allReviewers = await _userRepository.fetchReviewers();
      candidates = allReviewers
          .where((reviewer) => reviewer.subjects.contains(paper.subject))
          .toList();
    }

    if (candidates.isEmpty) {
      final fallback = await _userRepository.fetchReviewers();
      candidates = fallback;
    }

    if (candidates.isEmpty) {
      return null;
    }

    final reviewer = candidates[_random.nextInt(candidates.length)];
    await _paperRepository.assignReviewer(
      paperId: paper.id,
      reviewerId: reviewer.uid,
    );
    return reviewer.uid;
  }
}
