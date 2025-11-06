import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../common/controllers/loading_controller.dart';
import '../../../submissions/controllers/submission_controller.dart';

class ReviewerAssignedPapersPage extends StatelessWidget {
  const ReviewerAssignedPapersPage({super.key});

  SubmissionController get _submissionController => Get.find<SubmissionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final assignments = _submissionController.reviewerAssignments;
      if (assignments.isEmpty) {
        return const Center(child: Text('No assignments awaiting your review.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final paper = assignments[index];
          return _AssignmentCard(paper: paper);
        },
      );
    });
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.paper});

  final ResearchPaper paper;

  SubmissionController get _submissionController => Get.find<SubmissionController>();
  AuthController get _authController => Get.find<AuthController>();
  LoadingController get _loadingController => Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, color: AppColors.indigo600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(paper.title, style: Theme.of(context).textTheme.titleLarge),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openReviewSheet(context),
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
            if (paper.fileUrl != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _openFile(context, paper.fileUrl!),
                icon: const Icon(Icons.cloud_download_outlined),
                label: const Text('Download manuscript'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openReviewSheet(BuildContext context) async {
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
                reviewerId: _authController.currentUser.value!.id,
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
                            Text('Abstract', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              paper.abstractText,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                            ),
                            if (paper.fileUrl != null) ...[
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () => _openFile(context, paper.fileUrl!),
                                icon: const Icon(Icons.cloud_download_outlined),
                                label: const Text('Download manuscript'),
                              ),
                            ],
                            if (paper.content != null) ...[
                              const SizedBox(height: 16),
                              Text('Full text', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Container(
                                constraints: const BoxConstraints(maxHeight: 260),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.gray200),
                                  color: Colors.white,
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      paper.content!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(height: 1.6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                      onDeleted: () => setState(() => improvementList.remove(item)),
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
                                        paper.content?.substring(
                                              highlight.startOffset,
                                              min(highlight.endOffset, paper.content!.length),
                                            ) ??
                                            paper.abstractText.substring(
                                              highlight.startOffset,
                                              min(highlight.endOffset, paper.abstractText.length),
                                            ),
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
                          await _loadingController.during(() => _submissionController.recordReviewDecision(
                                paper: paper,
                                decision: decision,
                                summary: summaryController.text.trim(),
                                improvementPoints: improvementList,
                                highlights: highlights,
                              ));
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

  Future<void> _openFile(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open file')),
        );
      }
    }
  }
}
