import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/department.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../../admin/domain/settings_providers.dart';
import '../../../../shared/domain/department_providers.dart';
import '../../../presentation/controllers/paper_submission_controller.dart';

class StudentPaperSubmissionView extends ConsumerStatefulWidget {
  const StudentPaperSubmissionView({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<StudentPaperSubmissionView> createState() =>
      _StudentPaperSubmissionViewState();
}

class _StudentPaperSubmissionViewState
    extends ConsumerState<StudentPaperSubmissionView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _departmentId;
  String? _subject;
  PaperVisibility _visibility = PaperVisibility.private;
  bool _uploadFile = true;
  PlatformFile? _pickedFile;
  File? _localFile;
  Uint8List? _fileBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
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

  Future<void> _handleSubmit(List<Department> departments) async {
    if (!_formKey.currentState!.validate()) return;

    if (_uploadFile && _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload.')),
      );
      return;
    }

    final department = departments.firstWhere(
      (dept) => dept.id == _departmentId,
      orElse: () => Department(id: '', name: '', subjects: const []),
    );

    await ref
        .read(paperSubmissionControllerProvider.notifier)
        .submitPaper(
          author: widget.user,
          title: _titleController.text.trim(),
          department: department.name,
          subject: _subject ?? '',
          visibility: _visibility,
          plainText: _uploadFile ? null : _contentController.text.trim(),
          file: _uploadFile ? _localFile : null,
          fileBytes: _uploadFile ? _fileBytes : null,
          fileName: _uploadFile ? _pickedFile?.name : null,
        );

    final currentState = ref.read(paperSubmissionControllerProvider);
    if (currentState.hasError) {
      return;
    }

    if (mounted) {
      _formKey.currentState!.reset();
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _pickedFile = null;
        _localFile = null;
        _fileBytes = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paper submitted successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to submission controller changes here (WidgetRef available).
    ref.listen(paperSubmissionControllerProvider, (previous, next) {
      if (previous?.hasError != true && next.hasError) {
        final message = next.error?.toString() ?? 'Failed to submit paper.';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        });
      }
    });

    final departmentsAsync = ref.watch(departmentsStreamProvider);
    final submissionState = ref.watch(paperSubmissionControllerProvider);
    final aiEnabled = ref.watch(aiReviewEnabledProvider);

    return departmentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Unable to load departments: $error')),
      data: (departments) {
        final selectedDepartment = departments.firstWhere(
          (dept) => dept.id == _departmentId,
          orElse: () => Department(id: '', name: '', subjects: const []),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Submit a Research Paper',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (submissionState.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aiEnabled
                        ? 'AI pre-review is enabled. Expect automated insights before human review.'
                        : 'AI pre-review is currently disabled. Your paper will go directly to human review.',
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Paper title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _departmentId,
                                items: departments
                                    .map(
                                      (dept) => DropdownMenuItem(
                                        value: dept.id,
                                        child: Text(dept.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() {
                                  _departmentId = value;
                                  _subject = null;
                                }),
                                decoration: const InputDecoration(
                                  labelText: 'Department',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                    ? 'Select a department'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _subject,
                                items: selectedDepartment.subjects
                                    .map(
                                      (subject) => DropdownMenuItem(
                                        value: subject,
                                        child: Text(subject),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _subject = value),
                                decoration: const InputDecoration(
                                  labelText: 'Subject',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                    ? 'Select a subject'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: true,
                              label: Text('Upload File'),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text('Use Editor'),
                            ),
                          ],
                          selected: <bool>{_uploadFile},
                          onSelectionChanged: (value) => setState(() {
                            _uploadFile = value.first;
                          }),
                        ),
                        const SizedBox(height: 16),
                        if (_uploadFile)
                          _FilePickerSection(
                            pickedFile: _pickedFile,
                            onPick: _pickFile,
                            onClear: () => setState(() {
                              _pickedFile = null;
                              _localFile = null;
                              _fileBytes = null;
                            }),
                          )
                        else
                          TextFormField(
                            controller: _contentController,
                            maxLines: 15,
                            decoration: const InputDecoration(
                              labelText: 'Research content',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (!_uploadFile &&
                                  (value == null || value.trim().isEmpty)) {
                                return 'Please provide the paper content.';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          children: PaperVisibility.values
                              .map(
                                (visibility) => ChoiceChip(
                                  label: Text(visibility.name.toUpperCase()),
                                  selected: _visibility == visibility,
                                  onSelected: (_) =>
                                      setState(() => _visibility = visibility),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: submissionState.isLoading
                              ? null
                              : () => _handleSubmit(departments),
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Submit Paper'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilePickerSection extends StatelessWidget {
  const _FilePickerSection({
    required this.pickedFile,
    required this.onPick,
    required this.onClear,
  });

  final PlatformFile? pickedFile;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.attach_file),
          label: const Text('Choose File'),
        ),
        if (pickedFile != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withAlpha((0.2 * 255).round()),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickedFile!.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(pickedFile!.size / 1024).toStringAsFixed(1)} KB',
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
