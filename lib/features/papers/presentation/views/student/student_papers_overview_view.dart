import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../domain/paper_providers.dart';
import '../../controllers/paper_submission_controller.dart';

class StudentPapersOverviewView extends ConsumerWidget {
  const StudentPapersOverviewView({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final papersAsync = ref.watch(userPapersProvider(user.uid));

    return papersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error fetching papers: $error')),
      data: (papers) {
        if (papers.isEmpty) {
          return const Center(
            child: Text('No submissions yet. Submit your first research paper!'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: papers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final paper = papers[index];
            return _PaperCard(user: user, paper: paper);
          },
        );
      },
    );
  }
}

class _PaperCard extends ConsumerWidget {
  const _PaperCard({required this.user, required this.paper});

  final AppUser user;
  final ResearchPaper paper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(context, paper.status);
    final formatter = DateFormat('MMM d, y • h:mm a');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    paper.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(
                  backgroundColor: statusColor.withAlpha((0.1 * 255).round()),
                  label: Text(
                    paper.status.name.toUpperCase(),
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Department: ${paper.department} • Subject: ${paper.subject}'),
            const SizedBox(height: 4),
            Text('Visibility: ${paper.visibility.name}'),
            const SizedBox(height: 8),
            Text('Submitted ${formatter.format(paper.createdAt)}'),
            const SizedBox(height: 12),
            if (paper.aiFeedback != null) ...[
              Text(
                'AI Feedback',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(paper.aiFeedback!.summary),
              if (paper.aiFeedback!.suggestions.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Suggestions:'),
                const SizedBox(height: 4),
                ...paper.aiFeedback!.suggestions.map((suggestion) => Text('• $suggestion')),
              ],
              const SizedBox(height: 12),
            ],
            if (paper.reviewerComments != null && paper.reviewerComments!.isNotEmpty) ...[
              Text(
                'Reviewer Comments',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(paper.reviewerComments!),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                if (paper.fileUrl != null)
                  TextButton.icon(
                    onPressed: () => _openFile(context, paper.fileUrl!),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open File'),
                  ),
                const Spacer(),
                if (paper.status == PaperStatus.reverted)
                  FilledButton.tonal(
                    onPressed: () => _showResubmitSheet(context, ref, paper),
                    child: const Text('Resubmit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, PaperStatus status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case PaperStatus.submitted:
        return scheme.primary;
      case PaperStatus.aiReview:
        return scheme.secondary;
      case PaperStatus.underReview:
        return scheme.tertiary;
      case PaperStatus.reverted:
        return scheme.error;
      case PaperStatus.approved:
        return scheme.primaryContainer;
      case PaperStatus.published:
        return scheme.primary;
    }
  }

  Future<void> _showResubmitSheet(
    BuildContext context,
    WidgetRef ref,
    ResearchPaper paper,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => StudentResubmitSheet(user: user, paper: paper),
    );
  }

  Future<void> _openFile(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Unable to open the paper file.')),
      );
    }
  }
}

class StudentResubmitSheet extends ConsumerStatefulWidget {
  const StudentResubmitSheet({super.key, required this.user, required this.paper});

  final AppUser user;
  final ResearchPaper paper;

  @override
  ConsumerState<StudentResubmitSheet> createState() => _StudentResubmitSheetState();
}

class _StudentResubmitSheetState extends ConsumerState<StudentResubmitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  PlatformFile? _pickedFile;
  File? _localFile;
  Uint8List? _fileBytes;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'docx', 'doc', 'txt'],
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    File? local;
    Uint8List? bytes = file.bytes;

    if (!kIsWeb && file.path != null) {
      local = File(file.path!);
      bytes = await local.readAsBytes();
    }

    setState(() {
      _pickedFile = file;
      _localFile = local;
      _fileBytes = bytes;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    await ref.read(paperSubmissionControllerProvider.notifier).resubmitPaper(
          author: widget.user,
          paper: widget.paper,
          plainText: _contentController.text.trim().isEmpty ? null : _contentController.text.trim(),
          file: _localFile,
          fileBytes: _fileBytes,
          fileName: _pickedFile?.name,
        );

    final currentState = ref.read(paperSubmissionControllerProvider);
    if (currentState.hasError) {
      return;
    }

    if (mounted) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Paper resubmitted for review.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(paperSubmissionControllerProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resubmit "${widget.paper.title}"',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Updated notes or content (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach new file (optional)'),
                ),
                const SizedBox(width: 12),
                if (_pickedFile != null) Expanded(child: Text(_pickedFile!.name)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: submissionState.isLoading ? null : _submit,
                  child: submissionState.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Resubmit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
