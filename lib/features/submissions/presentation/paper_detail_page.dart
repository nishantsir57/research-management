import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/paper_comment.dart';
import '../../../data/models/research_paper.dart';
import '../../admin/controllers/department_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../common/controllers/user_directory_controller.dart';
import '../controllers/submission_controller.dart';

class PaperDetailPage extends StatefulWidget {
  const PaperDetailPage({super.key, required this.paperId});

  final String paperId;

  @override
  State<PaperDetailPage> createState() => _PaperDetailPageState();
}

class _PaperDetailPageState extends State<PaperDetailPage> {
  final SubmissionController _submissionController = Get.find<
      SubmissionController>();
  final AuthController _authController = Get.find<AuthController>();
  final UserDirectoryController _userDirectoryController =
  Get.find<UserDirectoryController>();
  final DepartmentController _departmentController = Get.find<
      DepartmentController>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    await _submissionController.addComment(
      paperId: widget.paperId,
      content: text,
    );
    _commentController.clear();
  }

  String _userName(String userId) {
    return _userDirectoryController.users
        .firstWhereOrNull((user) => user.id == userId)
        ?.displayName ??
        userId;
  }

  String _departmentName(String departmentId) {
    return _departmentController.departments
        .firstWhereOrNull((dept) => dept.id == departmentId)
        ?.name ??
        departmentId;
  }

  String _subjectName(String departmentId, String subjectId) {
    final department = _departmentController.departments
        .firstWhereOrNull((dept) => dept.id == departmentId);
    if (department == null) return subjectId;
    return department.subjects
        .firstWhereOrNull((subject) => subject.id == subjectId)
        ?.name ??
        subjectId;
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser.value;
    final paperStream = _submissionController.paperStream(widget.paperId);
    final commentsStream = _submissionController.commentsStream(widget.paperId);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Paper details'),
        ),
        body: StreamBuilder<ResearchPaper?>(
            stream: paperStream,
            builder: (context, paperSnapshot) {
              if (paperSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final paper = paperSnapshot.data;
              if (paper == null) {
                return const Center(child: Text('Paper not found.'));
              }
              return Obx(() {
                final ownerName = _userName(paper.ownerId);
                final departmentName = _departmentName(paper.departmentId);
                final subjectName = _subjectName(
                    paper.departmentId, paper.subjectId);
                final reviewerName = paper.primaryReviewerId != null
                    ? _userName(paper.primaryReviewerId!)
                    : 'Pending assignment';
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paper.title, style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('Owner: $ownerName')),
                          Chip(label: Text('Department: $departmentName')),
                          Chip(label: Text('Subject: $subjectName')),
                          Chip(label: Text('Reviewer: $reviewerName')),
                          Chip(label: Text(
                              'Visibility: ${paper.visibility.label}')),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Abstract', style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        paper.abstractText,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(height: 1.6),
                      ),
                      if (paper.content != null) ...[
                        const SizedBox(height: 24),
                        Text('Full content', style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          paper.content!,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(height: 1.6),
                        ),
                      ],
                      if (paper.aiReview != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: AppColors.pearl50,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Review Summary',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                paper.aiReview!.summary,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.gray600),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text('Comments', style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium),
                      const SizedBox(height: 8),
                      StreamBuilder<List<PaperComment>>(
                        stream: commentsStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final comments = snapshot.data!;
                          if (comments.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.gray200),
                              ),
                              child: Text(
                                'No comments yet. Start the discussion!',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                            );
                          }
                          return Column(
                            children: comments
                                .map(
                                  (comment) =>
                                  ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(comment.content),
                                    subtitle: Text(
                                      'by ${_userName(comment.authorId)}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.gray500),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${comment.likedBy.length}'),
                                        IconButton(
                                          icon: Icon(
                                            comment.likedBy.contains(user?.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: comment.likedBy.contains(
                                                user?.id)
                                                ? AppColors.violet500
                                                : AppColors.gray400,
                                          ),
                                          onPressed: user == null
                                              ? null
                                              : () =>
                                              _submissionController
                                                  .toggleCommentLike(
                                                paperId: widget.paperId,
                                                commentId: comment.id,
                                                like: !comment.likedBy.contains(
                                                    user.id),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                                .toList(),
                          );
                        },
                      ),
                      if (user != null) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _commentController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Add a comment',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send_outlined),
                              onPressed: _postComment,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              );
            }));
  }
}
