import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../auth/providers/auth_controller.dart';
import '../../../submissions/domain/submission_repository.dart';
import '../../../submissions/providers/submission_providers.dart';

class ReviewerAssignedPapersPage extends ConsumerWidget {
  const ReviewerAssignedPapersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(reviewerAssignmentsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: assignmentsAsync.when(
        data: (papers) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assigned submissions', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Review manuscripts assigned to you. Provide structured feedback, highlights, and decisions.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            if (papers.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inbox_outlined, color: AppColors.gray500),
                    const SizedBox(width: 12),
                    Text(
                      'No assignments awaiting your review.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: papers
                    .map((paper) => _AssignmentCard(
                          paper: paper,
                        ))
                    .toList(),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Unable to load assignments: $error'),
      ),
    );
  }
}

class _AssignmentCard extends ConsumerWidget {
  const _AssignmentCard({required this.paper});

  final ResearchPaper paper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Icon(Icons.description_outlined, color: AppColors.indigo600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  paper.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openReviewSheet(context, ref, paper),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Review'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            paper.abstractText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          if (paper.aiReview != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lilac200),
                color: AppColors.pearl50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gemini pre-review summary',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    paper.aiReview!.summary,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.gray600, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Future<void> _openReviewSheet(
    BuildContext context,
    WidgetRef ref,
    ResearchPaper paper,
  ) async {
    final summaryController = TextEditingController();
    final improvementController = TextEditingController();
    final highlightExcerptController = TextEditingController();
    final highlightNoteController = TextEditingController();
    final improvementList = <String>[];
    final highlights = <HighlightAnnotation>[];
    ReviewDecision decision = ReviewDecision.approve;
    Color highlightColor = Colors.amber;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> addImprovement() async {
              final text = improvementController.text.trim();
              if (text.isEmpty) return;
              setState(() {
                improvementList.add(text);
                improvementController.clear();
              });
            }

            Future<void> addHighlight() async {
              final excerpt = highlightExcerptController.text.trim();
              if (excerpt.isEmpty) return;
              final content = paper.content ?? paper.abstractText;
              final start = content.toLowerCase().indexOf(excerpt.toLowerCase());
              if (start == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Excerpt not found in content')),
                );
                return;
              }
              final highlight = HighlightAnnotation(
                id: UniqueKey().toString(),
                reviewerId: '',
                startOffset: start,
                endOffset: start + excerpt.length,
                colorHex: '#${highlightColor.value.toRadixString(16).substring(2)}',
                note: highlightNoteController.text.trim(),
                createdAt: DateTime.now(),
              );
              setState(() {
                highlights.add(highlight);
                highlightExcerptController.clear();
                highlightNoteController.clear();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(paper.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Abstract',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              paper.abstractText,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            if (paper.content != null)
                              ExpansionTile(
                                title: const Text('Full text'),
                                children: [
                                  Text(
                                    paper.content!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(height: 1.6),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: summaryController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Review summary',
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: improvementController,
                              decoration: InputDecoration(
                                labelText: 'Improvement suggestion',
                                suffixIcon: IconButton(
                                  onPressed: addImprovement,
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                              onSubmitted: (_) => addImprovement(),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: improvementList
                                  .map(
                                    (item) => Chip(
                                      label: Text(item),
                                      deleteIcon: const Icon(Icons.close),
                                      onDeleted: () =>
                                          setState(() => improvementList.remove(item)),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            TextField(
                              controller: highlightExcerptController,
                              decoration: const InputDecoration(
                                labelText: 'Excerpt to highlight',
                                helperText: 'Paste text snippet to highlight in the content',
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: highlightNoteController,
                              decoration: const InputDecoration(
                                labelText: 'Highlight note',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Color'),
                                const SizedBox(width: 12),
                                DropdownButton<Color>(
                                  value: highlightColor,
                                  items: [
                                    Colors.amber,
                                    Colors.lightBlue,
                                    Colors.pinkAccent,
                                    Colors.greenAccent,
                                  ]
                                      .map(
                                        (color) => DropdownMenuItem(
                                          value: color,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (color) => setState(() => highlightColor = color!),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: addHighlight,
                                  icon: const Icon(Icons.highlight_alt_outlined),
                                  label: const Text('Add highlight'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: highlights
                                  .map(
                                    (highlight) => Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: Color(
                                          int.parse('FF${highlight.colorHex.substring(1)}',
                                              radix: 16),
                                        ),
                                      ),
                                      label: Text(
                                        '${paper.content?.substring(highlight.startOffset, min(highlight.endOffset, paper.content!.length)) ?? paper.abstractText.substring(highlight.startOffset, min(highlight.endOffset, paper.abstractText.length))}',
                                      ),
                                      onDeleted: () => setState(() => highlights.remove(highlight)),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<ReviewDecision>(
                      segments: ReviewDecision.values
                          .map(
                            (decisionValue) => ButtonSegment(
                              value: decisionValue,
                              label: Text(decisionValue.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      selected: <ReviewDecision>{decision},
                      onSelectionChanged: (value) => setState(() {
                        decision = value.first;
                      }),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final repository = ref.read(submissionRepositoryProvider);
                          await repository.recordReviewDecision(
                            paper: paper,
                            reviewerId: ref.read(currentAppUserProvider)!.id,
                            decision: decision,
                            summary: summaryController.text.trim(),
                            improvementPoints: improvementList,
                            highlights: highlights,
                          );
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Submit review'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
