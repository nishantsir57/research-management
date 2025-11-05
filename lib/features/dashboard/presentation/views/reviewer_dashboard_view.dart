import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/models/research_paper.dart';
import '../../../../core/models/reviewer_highlight.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../papers/domain/paper_providers.dart';
import '../../../reviewer/domain/reviewer_review_controller.dart';

class ReviewerDashboardView extends ConsumerStatefulWidget {
  const ReviewerDashboardView({super.key});

  @override
  ConsumerState<ReviewerDashboardView> createState() => _ReviewerDashboardViewState();
}

class _ReviewerDashboardViewState extends ConsumerState<ReviewerDashboardView> {
  ResearchPaper? _selectedPaper;

  @override
  Widget build(BuildContext context) {
    final reviewerAsync = ref.watch(authUserChangesProvider);

    return reviewerAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Error: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Reviewer account missing.')));
        }
        return _buildDashboard(context, user);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, AppUser reviewer) {
    final papersAsync = ref.watch(reviewerAssignedPapersProvider(reviewer.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviewer Workspace'),
      ),
      body: papersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load papers: $error')),
        data: (papers) {
          if (papers.isEmpty) {
            return const Center(child: Text('No papers assigned at the moment.'));
          }

          _selectedPaper ??= papers.first;

          return Row(
            children: [
              SizedBox(
                width: 320,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: papers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final paper = papers[index];
                    final isSelected = _selectedPaper?.id == paper.id;
                    return ListTile(
                      selected: isSelected,
                      title: Text(paper.title),
                      subtitle: Text('Status: ${paper.status.name}'),
                      onTap: () => setState(() => _selectedPaper = paper),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedPaper == null
                    ? const Center(child: Text('Select a paper to start reviewing.'))
                    : _ReviewerPaperDetail(paper: _selectedPaper!),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewerPaperDetail extends ConsumerStatefulWidget {
  const _ReviewerPaperDetail({required this.paper});

  final ResearchPaper paper;

  @override
  ConsumerState<_ReviewerPaperDetail> createState() => _ReviewerPaperDetailState();
}

class _ReviewerPaperDetailState extends ConsumerState<_ReviewerPaperDetail> {
  final _commentsController = TextEditingController();
  final List<ReviewerHighlight> _highlights = [];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewerReviewControllerProvider);
    final formatter = DateFormat('MMM d, y h:mm a');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.paper.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Assigned ${formatter.format(widget.paper.createdAt)}'),
          const SizedBox(height: 12),
          if (widget.paper.contentText != null && widget.paper.contentText!.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Text(widget.paper.contentText!),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  widget.paper.fileUrl == null
                      ? 'No content provided.'
                      : 'This submission is a file upload. Download to review the content.',
                ),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: _addHighlight,
                icon: const Icon(Icons.highlight_alt_outlined),
                label: const Text('Add Highlight'),
              ),
              FilledButton.icon(
                onPressed: reviewState.isLoading ? null : () => _approve(),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Approve'),
              ),
              FilledButton.tonalIcon(
                onPressed: reviewState.isLoading ? null : () => _revert(),
                icon: const Icon(Icons.undo),
                label: const Text('Request Changes'),
              ),
              if (reviewState.isLoading)
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Reviewer comments (required for revert)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (_highlights.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Highlights to share with the student'),
                const SizedBox(height: 8),
                ..._highlights.map((highlight) => ListTile(
                      title: Text(highlight.text ?? 'Highlight ${highlight.id}'),
                      subtitle: Text(highlight.comment),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _highlights.remove(highlight)),
                      ),
                    )),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _addHighlight() async {
    final textController = TextEditingController();
    final noteController = TextEditingController();
    final result = await showDialog<ReviewerHighlight>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Highlight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Excerpt / Section',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (noteController.text.trim().isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                ReviewerHighlight(
                  id: const Uuid().v4(),
                  startIndex: 0,
                  endIndex: 0,
                  comment: noteController.text.trim(),
                  text: textController.text.trim().isEmpty ? null : textController.text.trim(),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() => _highlights.add(result));
    }
  }

  Future<void> _approve() async {
    await ref.read(reviewerReviewControllerProvider.notifier).approvePaper(
          paper: widget.paper,
          comments: _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paper approved.')),
      );
    }
  }

  Future<void> _revert() async {
    final comments = _commentsController.text.trim();
    if (comments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comments required to request changes.')),
      );
      return;
    }

    await ref.read(reviewerReviewControllerProvider.notifier).revertPaper(
          paper: widget.paper,
          comments: comments,
          highlights: _highlights,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revert request sent to student.')),
      );
    }
  }
}
