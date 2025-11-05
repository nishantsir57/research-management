import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/research_paper.dart';
import '../../../core/providers/firebase_providers.dart';
import '../data/research_paper_repository.dart';

final researchPaperRepositoryProvider = Provider<ResearchPaperRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ResearchPaperRepository(firestore);
});

final userPapersProvider = StreamProvider.family<List<ResearchPaper>, String>((ref, userId) {
  return ref.watch(researchPaperRepositoryProvider).watchByAuthor(userId);
});

final allPapersProvider = StreamProvider<List<ResearchPaper>>((ref) {
  return ref.watch(researchPaperRepositoryProvider).watchAllPapers();
});

final reviewerAssignedPapersProvider =
    StreamProvider.family<List<ResearchPaper>, String>((ref, reviewerId) {
  return ref.watch(researchPaperRepositoryProvider).watchAssignedToReviewer(reviewerId);
});

final paperDetailsProvider = StreamProvider.family<ResearchPaper?, String>((ref, paperId) {
  return ref.watch(researchPaperRepositoryProvider).watchPaper(paperId);
});
