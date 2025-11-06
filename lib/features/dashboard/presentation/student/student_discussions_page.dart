import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/discussion.dart';
import '../../../discussions/providers/discussion_providers.dart';
import '../../../common/providers/user_directory_provider.dart';

class StudentDiscussionsPage extends ConsumerWidget {
  const StudentDiscussionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(discussionThreadsProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateThreadDialog(context, ref),
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('Start discussion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Open discussions', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Collaborate publicly with the Kohinchha community. Discussions are visible to all roles.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            threadsAsync.when(
              data: (threads) => Column(
                children: threads.map((thread) => _ThreadCard(thread: thread)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(
                'Failed to load discussions: $error',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateThreadDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();
    final tags = <String>[];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Start a new discussion'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Topic title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Question or context',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: tagsController,
                      decoration: InputDecoration(
                        labelText: 'Tags',
                        suffixIcon: IconButton(
                          onPressed: () {
                            final tag = tagsController.text.trim();
                            if (tag.isEmpty) return;
                            setState(() => tags.add(tag));
                            tagsController.clear();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              onDeleted: () => setState(() => tags.remove(tag)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  return;
                }
                await ref.read(discussionControllerProvider).createThread(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      tags: tags,
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _ThreadCard extends ConsumerWidget {
  const _ThreadCard({required this.thread});

  final DiscussionThread thread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDirectory = ref.watch(userDirectoryProvider).maybeWhen(
          data: (users) => users,
          orElse: () => const [],
        );
    final authorName = userDirectory.firstWhere(
      (user) => user.id == thread.createdBy,
      orElse: () => userDirectory.isNotEmpty ? userDirectory.first : null,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.forum_outlined, color: AppColors.indigo600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  thread.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => _openThread(context, ref, thread),
                child: const Text('View thread'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            thread.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: thread.tags
                .map(
                  (tag) => Chip(
                    label: Text('#$tag'),
                    backgroundColor: AppColors.pearl50,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.indigo600,
                child: Text(
                  authorName?.displayName.substring(0, 1).toUpperCase() ?? 'A',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                authorName?.displayName ?? 'Anonymous',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
              ),
              const Spacer(),
              const Icon(Icons.people_outline, size: 18, color: AppColors.gray500),
              const SizedBox(width: 4),
              Text(
                '${thread.participantCount} participants',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openThread(BuildContext context, WidgetRef ref, DiscussionThread thread) async {
    final commentController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final commentsProvider = discussionCommentsProvider(thread.id);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(thread.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final commentsAsync = ref.watch(commentsProvider);
                    return commentsAsync.when(
                      data: (comments) => ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(comment.content),
                            subtitle: Text(
                              '${comment.upvotes.length} upvotes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.gray500),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.thumb_up_outlined,
                                color: comment.upvotes.contains('me')
                                    ? AppColors.indigo600
                                    : AppColors.gray400,
                              ),
                              onPressed: () => ref
                                  .read(discussionControllerProvider)
                                  .toggleUpvote(
                                    threadId: thread.id,
                                    commentId: comment.id,
                                    upvote: !comment.upvotes.contains('me'),
                                  ),
                            ),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error loading comments: $error'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Add a comment',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_outlined),
                    onPressed: () async {
                      final text = commentController.text.trim();
                      if (text.isEmpty) return;
                      await ref.read(discussionControllerProvider).addComment(
                            threadId: thread.id,
                            content: text,
                          );
                      commentController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
