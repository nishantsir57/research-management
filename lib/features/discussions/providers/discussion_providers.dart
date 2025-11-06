import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/discussion.dart';
import '../../auth/providers/auth_controller.dart';
import '../domain/discussion_repository.dart';

final discussionThreadsProvider = StreamProvider<List<DiscussionThread>>((ref) {
  final repository = ref.watch(discussionRepositoryProvider);
  return repository.watchThreads();
});

final discussionCommentsProvider =
    StreamProvider.family<List<DiscussionComment>, String>((ref, threadId) {
  final repository = ref.watch(discussionRepositoryProvider);
  return repository.watchThreadComments(threadId);
});

final discussionControllerProvider =
    Provider<DiscussionController>((ref) => DiscussionController(ref: ref));

class DiscussionController {
  DiscussionController({required this.ref});

  final Ref ref;

  DiscussionRepository get _repository => ref.read(discussionRepositoryProvider);

  Future<void> createThread({
    required String title,
    required String description,
    List<String>? tags,
    String? departmentId,
    String? subjectId,
  }) async {
    final user = ref.read(currentAppUserProvider);
    if (user == null) throw StateError('Not authenticated');
    await _repository.createThread(
      creatorId: user.id,
      title: title,
      description: description,
      tags: tags,
      departmentId: departmentId,
      subjectId: subjectId,
    );
  }

  Future<void> addComment({
    required String threadId,
    required String content,
  }) async {
    final user = ref.read(currentAppUserProvider);
    if (user == null) throw StateError('Not authenticated');
    await _repository.addComment(
      threadId: threadId,
      authorId: user.id,
      content: content,
    );
  }

  Future<void> toggleUpvote({
    required String threadId,
    required String commentId,
    required bool upvote,
  }) async {
    final user = ref.read(currentAppUserProvider);
    if (user == null) throw StateError('Not authenticated');
    await _repository.toggleUpvote(
      threadId: threadId,
      commentId: commentId,
      userId: user.id,
      upvote: upvote,
    );
  }
}
