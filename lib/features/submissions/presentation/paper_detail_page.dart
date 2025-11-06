import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/providers/auth_controller.dart';
import '../domain/submission_repository.dart';
import '../providers/submission_providers.dart';

class PaperDetailPage extends ConsumerStatefulWidget {
  const PaperDetailPage({super.key, required this.paperId});

  final String paperId;

  @override
  ConsumerState<PaperDetailPage> createState() => _PaperDetailPageState();
}

class _PaperDetailPageState extends ConsumerState<PaperDetailPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paperAsync = ref.watch(paperProvider(widget.paperId));
    final commentsAsync = ref.watch(paperCommentsProvider(widget.paperId));
    final currentUser = ref.watch(currentAppUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paper details'),
      ),
      body: paperAsync.when(
        data: (paper) {
          if (paper == null) {
            return const Center(child: Text('Paper not found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(paper.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    Chip(label: Text('Owner: ${paper.ownerId}')),
                    Chip(label: Text('Department: ${paper.departmentId}')),
                    Chip(label: Text('Subject: ${paper.subjectId}')),
                    Chip(label: Text('Visibility: ${paper.visibility.label}')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Abstract',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  paper.abstractText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                if (paper.content != null) ...[
                  const SizedBox(height: 16),
                  Text('Full content', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    paper.content!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.6),
                  ),
                ],
                const SizedBox(height: 24),
                Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                commentsAsync.when(
                  data: (comments) => Column(
                    children: comments
                        .map(
                          (comment) => ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(comment.content),
                            subtitle: Text(
                              'by ${comment.authorId}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.gray500),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Unable to load comments: $error'),
                ),
                const SizedBox(height: 16),
                if (currentUser != null)
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send_outlined),
                        onPressed: () async {
                          final text = _commentController.text.trim();
                          if (text.isEmpty) return;
                          await ref.read(submissionRepositoryProvider).addPaperComment(
                                paperId: paper.id,
                                authorId: currentUser.id,
                                content: text,
                              );
                          _commentController.clear();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Unable to load paper: $error'),
      ),
    );
  }
}
