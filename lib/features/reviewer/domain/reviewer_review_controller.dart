import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/research_paper.dart';
import '../../../core/models/reviewer_highlight.dart';
import '../../papers/data/research_paper_repository.dart';
import '../../papers/domain/paper_providers.dart';

final reviewerReviewControllerProvider = AutoDisposeAsyncNotifierProvider<ReviewerReviewController, void>(
  ReviewerReviewController.new,
);

class ReviewerReviewController extends AutoDisposeAsyncNotifier<void> {
  late final ResearchPaperRepository _paperRepository;

  @override
  FutureOr<void> build() {
    _paperRepository = ref.read(researchPaperRepositoryProvider);
  }

  Future<void> approvePaper({
    required ResearchPaper paper,
    String? comments,
  }) async {
    state = const AsyncLoading();
    try {
      await _paperRepository.updatePaperStatus(
        paperId: paper.id,
        status: PaperStatus.approved,
        reviewerComments: comments,
      );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> revertPaper({
    required ResearchPaper paper,
    required String comments,
    List<ReviewerHighlight> highlights = const [],
  }) async {
    state = const AsyncLoading();
    try {
      await _paperRepository.updatePaperStatus(
        paperId: paper.id,
        status: PaperStatus.reverted,
        reviewerComments: comments,
        highlights: highlights.map((highlight) => highlight.toMap()).toList(),
      );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
