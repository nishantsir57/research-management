import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../domain/paper_providers.dart';
import '../../controllers/paper_submission_controller.dart';
import '../../widgets/paper_card.dart';

class StudentPapersOverviewView extends ConsumerWidget {
  const StudentPapersOverviewView({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final papersAsync = ref.watch(userPapersProvider(user.uid));

    return papersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        print('Error fetching papers for user ${user.uid}: $error');
        return Center(child: Text('Error fetching papers: $error'));
      },
      data: (papers) {
        if (papers.isEmpty) {
          return const Center(
            child: Text('No submissions yet. Submit your first research paper!'),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _responsiveColumns(constraints.maxWidth);
            return MasonryGridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              itemCount: papers.length,
              itemBuilder: (context, index) {
                final paper = papers[index];
                return StudentPaperTile(user: user, paper: paper);
              },
            );
          },
        );
      },
    );
  }

  int _responsiveColumns(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }
}

class StudentPaperTile extends ConsumerWidget {
  const StudentPaperTile({required this.user, required this.paper});

  final AppUser user;
  final ResearchPaper paper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = DateFormat('MMM d, y • h:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaperCard(
          paper: paper,
          heroTag: 'paper-card-${paper.id}',
          onTap: () => context.go('/paper/${paper.id}'),
          onShare: () => _sharePaper(context, paper),
          showAuthor: false,
          highlightBadges: [
            _badge(context, Icons.schedule_rounded, 'Submitted ${formatter.format(paper.createdAt)}'),
            _badge(context, Icons.visibility_rounded, paper.visibility.name.toUpperCase()),
          ],
        ),
        const SizedBox(height: 12),
        _PaperInsights(
          paper: paper,
          onResubmit: () => _showResubmitSheet(context, ref, paper),
          onOpenFile: paper.fileUrl != null ? () => _openFile(context, paper.fileUrl!) : null,
        ),
      ],
    );
  }

  Widget _badge(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  Future<void> _showResubmitSheet(BuildContext context, WidgetRef ref, ResearchPaper paper) async {
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

  Future<void> _sharePaper(BuildContext context, ResearchPaper paper) async {
    final url = Uri.parse('https://researchhub.app/paper/${paper.id}');
    final shareText = url.toString();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.ios_share_rounded),
                title: const Text('Share via apps'),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareUri(url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy link'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paper link copied to clipboard.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaperInsights extends StatelessWidget {
  const _PaperInsights({
    required this.paper,
    this.onResubmit,
    this.onOpenFile,
  });

  final ResearchPaper paper;
  final VoidCallback? onResubmit;
  final VoidCallback? onOpenFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paper.aiFeedback != null) ...[
            _InsightHeader(icon: Icons.auto_awesome_rounded, label: 'AI Feedback'),
            const SizedBox(height: 6),
            Text(
              paper.aiFeedback!.summary,
              style: theme.textTheme.bodyMedium,
            ),
            if (paper.aiFeedback!.suggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...paper.aiFeedback!.suggestions.map((suggestion) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(suggestion)),
                    ],
                  )),
            ],
            const SizedBox(height: 20),
          ],
          if (paper.reviewerComments != null && paper.reviewerComments!.isNotEmpty) ...[
            _InsightHeader(icon: Icons.rate_review_outlined, label: 'Reviewer Comments'),
            const SizedBox(height: 6),
            Text(paper.reviewerComments!, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              if (onOpenFile != null)
                OutlinedButton.icon(
                  onPressed: onOpenFile,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Open submission'),
                ),
              if (onOpenFile != null) const SizedBox(width: 12),
              if (paper.status == PaperStatus.reverted && onResubmit != null)
                FilledButton.tonalIcon(
                  onPressed: onResubmit,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Resubmit'),
                ),
              const Spacer(),
              Chip(
                avatar: const Icon(Icons.layers_outlined, size: 16),
                label: Text('${paper.studentResubmissions.length} revisions'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightHeader extends StatelessWidget {
  const _InsightHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
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
