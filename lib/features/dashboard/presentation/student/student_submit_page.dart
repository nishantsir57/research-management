import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/providers/admin_settings_provider.dart';
import '../../../admin/providers/department_providers.dart';
import '../../../submissions/providers/submission_providers.dart';

class StudentSubmitPaperPage extends ConsumerStatefulWidget {
  const StudentSubmitPaperPage({super.key});

  @override
  ConsumerState<StudentSubmitPaperPage> createState() => _StudentSubmitPaperPageState();
}

class _StudentSubmitPaperPageState extends ConsumerState<StudentSubmitPaperPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _keywords = [];
  final _keywordController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedSubject;
  PaperFormat _selectedFormat = PaperFormat.pdf;
  PaperVisibility _selectedVisibility = PaperVisibility.public;
  bool _useTextSubmission = false;
  bool _isSubmitting = false;

  File? _selectedFile;
  Uint8List? _fileBytes;
  String? _fileName;

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final submitState = ref.watch(submitPaperControllerProvider);

    ref.listen(submitPaperControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (paper) {
          if (paper != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Paper "${paper.title}" submitted successfully')),
            );
            _formKey.currentState?.reset();
            _titleController.clear();
            _abstractController.clear();
            _contentController.clear();
            setState(() {
              _tags.clear();
              _keywords.clear();
              _selectedFile = null;
              _fileBytes = null;
              _fileName = null;
            });
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Submission failed: $error'),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submit a research paper', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Upload your manuscript or use the text editor. Select the relevant department and subject so we can assign the right reviewer.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              validator: ValidationBuilder().minLength(6).build(),
              decoration: const InputDecoration(
                labelText: 'Paper title',
                prefixIcon: Icon(Icons.title_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _abstractController,
              maxLines: 4,
              validator: ValidationBuilder().minLength(50).build(),
              decoration: const InputDecoration(
                labelText: 'Abstract',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            departmentsAsync.when(
              data: (departments) {
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      items: departments
                          .map(
                            (dept) => DropdownMenuItem(
                              value: dept.id,
                              child: Text(dept.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedDepartment = value;
                        _selectedSubject = null;
                      }),
                      validator: (value) => value == null ? 'Select a department' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        prefixIcon: Icon(Icons.menu_book_outlined),
                      ),
                      items: (_selectedDepartment != null)
                          ? departments
                              .firstWhere((dept) => dept.id == _selectedDepartment)
                              .subjects
                              .map(
                                (subject) => DropdownMenuItem(
                                  value: subject.id,
                                  child: Text(subject.name),
                                ),
                              )
                              .toList()
                          : const [],
                      onChanged: (value) => setState(() => _selectedSubject = value),
                      validator: (value) => value == null ? 'Select a subject' : null,
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Unable to load departments: $error'),
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: PaperFormat.values.map((format) => format == _selectedFormat).toList(),
              onPressed: (index) {
                setState(() => _selectedFormat = PaperFormat.values[index]);
              },
              borderRadius: BorderRadius.circular(18),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('PDF'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('DOC'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('TEXT'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: PaperVisibility.values
                  .map(
                    (visibility) => ChoiceChip(
                      label: Text(visibility.label),
                      selected: _selectedVisibility == visibility,
                      onSelected: (_) => setState(() => _selectedVisibility = visibility),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: _useTextSubmission,
              onChanged: (value) => setState(() => _useTextSubmission = value),
              title: const Text('Submit using text editor instead of file upload'),
            ),
            const SizedBox(height: 12),
            if (_useTextSubmission)
              TextField(
                controller: _contentController,
                minLines: 8,
                maxLines: 20,
                decoration: const InputDecoration(
                  labelText: 'Full content',
                  alignLabelWithHint: true,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Upload manuscript'),
                  ),
                  const SizedBox(height: 12),
                  if (_fileName != null)
                    Chip(
                      label: Text(_fileName!),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => setState(() {
                        _selectedFile = null;
                        _fileBytes = null;
                        _fileName = null;
                      }),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            _TagInput(
              label: 'Tags',
              controller: _tagController,
              values: _tags,
              onAdd: () {
                final value = _tagController.text.trim();
                if (value.isEmpty) return;
                setState(() => _tags.add(value));
                _tagController.clear();
              },
              onRemove: (tag) => setState(() => _tags.remove(tag)),
            ),
            const SizedBox(height: 16),
            _TagInput(
              label: 'Keywords',
              controller: _keywordController,
              values: _keywords,
              onAdd: () {
                final value = _keywordController.text.trim();
                if (value.isEmpty) return;
                setState(() => _keywords.add(value));
                _keywordController.clear();
              },
              onRemove: (keyword) => setState(() => _keywords.remove(keyword)),
            ),
            const SizedBox(height: 24),
            settingsAsync.when(
              data: (settings) => _AiInfoBanner(enabled: settings.aiPreReviewEnabled),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting || submitState.isLoading ? null : _submit,
                icon: const Icon(Icons.send_outlined),
                label: Text(submitState.isLoading ? 'Submitting...' : 'Submit for review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      withData: kIsWeb,
    );
    if (result == null) return;
    setState(() {
      _fileName = result.files.single.name;
      _fileBytes = result.files.single.bytes;
      _selectedFile =
          result.files.single.path != null ? File(result.files.single.path!) : null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_useTextSubmission && _selectedFile == null && _fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a manuscript or enable text submission')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final controller = ref.read(submitPaperControllerProvider.notifier);
    await controller.submit(
      title: _titleController.text.trim(),
      abstractText: _abstractController.text.trim(),
      content: _useTextSubmission ? _contentController.text.trim() : null,
      file: _useTextSubmission ? null : _selectedFile,
      fileBytes: _useTextSubmission ? null : _fileBytes,
      fileName: _useTextSubmission ? null : _fileName,
      format: _selectedFormat,
      visibility: _selectedVisibility,
      departmentId: _selectedDepartment!,
      subjectId: _selectedSubject!,
      tags: _tags,
      keywords: _keywords,
    );
    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }
}

class _TagInput extends StatelessWidget {
  const _TagInput({
    required this.label,
    required this.controller,
    required this.values,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final TextEditingController controller;
  final List<String> values;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map(
                (value) => Chip(
                  label: Text(value),
                  onDeleted: () => onRemove(value),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _AiInfoBanner extends StatelessWidget {
  const _AiInfoBanner({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled ? AppColors.pearl50 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: enabled ? AppColors.indigo600 : AppColors.gray200),
      ),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.auto_awesome_outlined : Icons.shield_outlined,
            color: enabled ? AppColors.indigo600 : AppColors.gray500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              enabled
                  ? 'Gemini pre-review will analyse your submission and provide insights before a reviewer receives it.'
                  : 'AI pre-review is currently disabled. Your submission will go directly to the reviewer queue.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
