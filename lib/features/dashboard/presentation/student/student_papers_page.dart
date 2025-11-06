import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/department.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/controllers/department_controller.dart';
import '../../../submissions/controllers/submission_controller.dart';

class StudentMyPapersPage extends StatefulWidget {
  const StudentMyPapersPage({super.key});

  @override
  State<StudentMyPapersPage> createState() => _StudentMyPapersPageState();
}

class _StudentMyPapersPageState extends State<StudentMyPapersPage> {
  PaperStatus? _statusFilter;
  PaperVisibility? _visibilityFilter;

  final SubmissionController _submissionController = Get.find<SubmissionController>();
  final DepartmentController _departmentController = Get.find<DepartmentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final papers = _submissionController.studentPapers;
      final departments = _departmentController.departments;
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My research papers', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Keep track of submissions, apply filters, and manage visibility or resubmissions.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<PaperStatus>(
                    value: _statusFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter by status',
                      prefixIcon: Icon(Icons.filter_alt_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All statuses')),
                      ...PaperStatus.values.map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status.label),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _statusFilter = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<PaperVisibility>(
                    value: _visibilityFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter by visibility',
                      prefixIcon: Icon(Icons.shield_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All visibility')),
                      ...PaperVisibility.values.map(
                        (visibility) => DropdownMenuItem(
                          value: visibility,
                          child: Text(visibility.label),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _visibilityFilter = value),
                  ),
                ),
              ],
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
                    Expanded(
                      child: Text(
                        'You have not submitted any papers yet.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: papers
                    .where((paper) {
                      final statusMatches =
                          _statusFilter == null || paper.status == _statusFilter;
                      final visibilityMatches =
                          _visibilityFilter == null || paper.visibility == _visibilityFilter;
                      return statusMatches && visibilityMatches;
                    })
                    .map(
                      (paper) => _PaperCard(
                        paper: paper,
                        departments: departments,
                        onResubmit: () => _showResubmitSheet(context, paper),
                        onVisibilityChange: (visibility) => _updateVisibility(paper, visibility),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      );
    });
  }

  Future<void> _updateVisibility(ResearchPaper paper, PaperVisibility visibility) async {
    await _submissionController.updatePaperVisibility(
      paperId: paper.id,
      visibility: visibility,
    );
    _showSnack('Visibility updated to ${visibility.label}');
  }

  Future<void> _showResubmitSheet(BuildContext context, ResearchPaper paper) async {
    final contentController = TextEditingController(text: paper.content ?? '');
    Uint8List? fileBytes;
    File? file;
    String? fileName;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              Future<void> pickFile() async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
                );
                if (result == null) return;
                if (kIsWeb) {
                  setModalState(() {
                    fileBytes = result.files.single.bytes;
                    fileName = result.files.single.name;
                    file = null;
                  });
                } else {
                  setModalState(() {
                    file = result.files.single.path != null ? File(result.files.single.path!) : null;
                    fileBytes = result.files.single.bytes;
                    fileName = result.files.single.name;
                  });
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resubmit paper',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Update content or upload a new file before resubmitting for review.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Update content (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickFile,
                        icon: const Icon(Icons.upload_file_outlined),
                        label: const Text('Upload new file'),
                      ),
                      const SizedBox(width: 12),
                      if (fileName != null)
                        Chip(
                          label: Text(fileName ?? ''),
                          onDeleted: () => setModalState(() {
                            fileBytes = null;
                            file = null;
                            fileName = null;
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedPaper = await _submissionController.resubmitPaper(
                          paper: paper,
                          updatedContent: contentController.text.trim().isEmpty
                              ? null
                              : contentController.text.trim(),
                          newFile: file,
                          newFileBytes: fileBytes,
                          newFileName: fileName,
                        );
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        _showPipelineUpdate(updatedPaper);
                      },
                      child: const Text('Resubmit'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPipelineUpdate(ResearchPaper paper) {
    switch (paper.status) {
      case PaperStatus.revisionsRequested:
        _showSnack('AI review requested additional changes. See feedback for details.');
        final aiReview = paper.aiReview;
        if (aiReview != null) {
          _showAiFeedbackDialog(aiReview);
        }
        break;
      case PaperStatus.underReview:
        _showSnack('Paper resubmitted. Reviewer has been notified.');
        break;
      case PaperStatus.submitted:
        _showSnack('Paper resubmitted. Awaiting reviewer assignment.');
        break;
      case PaperStatus.aiReview:
        _showSnack('Paper resubmitted and queued for AI review.');
        break;
      default:
        _showSnack('Paper resubmitted for review.');
    }
  }

  Future<void> _showAiFeedbackDialog(AiReviewResult review) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        Widget bullet(String text) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(dialogContext).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }

        return AlertDialog(
          title: const Text('AI review feedback'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  review.summary,
                  style: Theme.of(dialogContext).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Quality score: ${review.qualityScore.toStringAsFixed(1)}',
                  style: Theme.of(dialogContext)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Plagiarism risk: ${review.plagiarismRisk.toStringAsFixed(1)}%',
                  style: Theme.of(dialogContext).textTheme.bodySmall,
                ),
                if (review.strengths.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Strengths',
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...review.strengths.map(bullet),
                ],
                if (review.improvements.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Recommended improvements',
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...review.improvements.map(bullet),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.paper,
    required this.departments,
    required this.onResubmit,
    required this.onVisibilityChange,
  });

  final ResearchPaper paper;
  final List<Department> departments;
  final VoidCallback onResubmit;
  final ValueChanged<PaperVisibility> onVisibilityChange;

  @override
  Widget build(BuildContext context) {
    final departmentName =
        departments.firstWhereOrNull((dept) => dept.id == paper.departmentId)?.name ??
            paper.departmentId;
    final statusColor = _statusColor(paper.status);
    final statusIcon = _statusIcon(paper.status);

    return GestureDetector(
      onTap: () => Get.toNamed('${AppRoutes.paperDetail}/${paper.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    paper.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                PopupMenuButton<PaperVisibility>(
                  onSelected: onVisibilityChange,
                  itemBuilder: (context) => PaperVisibility.values
                      .map(
                        (visibility) => PopupMenuItem(
                          value: visibility,
                          child: Text(visibility.label),
                        ),
                      )
                      .toList(),
                  child: Chip(
                    avatar: const Icon(Icons.visibility_outlined, size: 18),
                    label: Text(paper.visibility.label),
                  ),
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
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _InfoChip(label: 'Department', value: departmentName),
                _InfoChip(label: 'Subject', value: paper.subjectId),
                _InfoChip(label: 'Format', value: paper.format.name.toUpperCase()),
                _InfoChip(label: 'Status', value: paper.status.label, color: statusColor),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (paper.canResubmit)
                  ElevatedButton.icon(
                    onPressed: onResubmit,
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('Resubmit'),
                  ),
                const Spacer(),
                if (paper.fileUrl != null)
                  TextButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(paper.fileUrl!);
                      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Unable to open file')),
                        );
                      }
                    },
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Download'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(PaperStatus status) {
    switch (status) {
      case PaperStatus.submitted:
      case PaperStatus.underReview:
        return AppColors.indigo600;
      case PaperStatus.aiReview:
        return AppColors.info;
      case PaperStatus.revisionsRequested:
        return AppColors.warning;
      case PaperStatus.approved:
      case PaperStatus.published:
        return AppColors.success;
      case PaperStatus.rejected:
        return AppColors.error;
      case PaperStatus.draft:
        return AppColors.gray500;
    }
  }

  IconData _statusIcon(PaperStatus status) {
    switch (status) {
      case PaperStatus.submitted:
      case PaperStatus.underReview:
        return Icons.pending_outlined;
      case PaperStatus.aiReview:
        return Icons.auto_fix_high_outlined;
      case PaperStatus.revisionsRequested:
        return Icons.feedback_outlined;
      case PaperStatus.approved:
      case PaperStatus.published:
        return Icons.verified_outlined;
      case PaperStatus.rejected:
        return Icons.block_outlined;
      case PaperStatus.draft:
        return Icons.edit_outlined;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value, style: TextStyle(color: color ?? AppColors.gray700)),
          ],
        ),
      ),
      backgroundColor: AppColors.pearl50,
    );
  }
}
