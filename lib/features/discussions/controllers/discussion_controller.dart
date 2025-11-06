import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/discussion.dart';
import '../../auth/controllers/auth_controller.dart';
import '../domain/discussion_repository.dart';

class DiscussionController extends GetxController {
  DiscussionController({DiscussionRepository? repository})
      : _repository = repository ?? DiscussionRepository();

  final DiscussionRepository _repository;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<DiscussionThread> threads = <DiscussionThread>[].obs;

  StreamSubscription<List<DiscussionThread>>? _threadSubscription;

  @override
  void onInit() {
    super.onInit();
    _threadSubscription = _repository.watchThreads().listen(threads.assignAll);
  }

  Stream<List<DiscussionComment>> commentsStream(String threadId) =>
      _repository.watchThreadComments(threadId);

  Future<void> createThread({
    required String title,
    required String description,
    List<String>? tags,
    String? departmentId,
    String? subjectId,
  }) async {
    final user = _authController.currentUser.value;
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
    final user = _authController.currentUser.value;
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
    final user = _authController.currentUser.value;
    if (user == null) throw StateError('Not authenticated');
    await _repository.toggleUpvote(
      threadId: threadId,
      commentId: commentId,
      userId: user.id,
      upvote: upvote,
    );
  }

  @override
  void onClose() {
    _threadSubscription?.cancel();
    super.onClose();
  }
}
