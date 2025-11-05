import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/paper_comment_repository.dart';

final paperCommentRepositoryProvider = Provider<PaperCommentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PaperCommentRepository(firestore);
});

final paperCommentsProvider = StreamProvider.family((ref, String paperId) {
  return ref.watch(paperCommentRepositoryProvider).watchComments(paperId);
});

final paperCommentCountProvider = StreamProvider.family<int, String>((ref, paperId) {
  return ref.watch(paperCommentRepositoryProvider).watchComments(paperId).map((comments) => comments.length);
});
