import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/discussion_repository.dart';

final discussionRepositoryProvider = Provider<DiscussionRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return DiscussionRepository(firestore);
});

final discussionsStreamProvider = StreamProvider((ref) {
  return ref.watch(discussionRepositoryProvider).watchDiscussions();
});

final discussionMessagesProvider =
    StreamProvider.family((ref, String discussionId) {
  return ref.watch(discussionRepositoryProvider).watchMessages(discussionId);
});
