import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/department.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/controllers/department_controller.dart';
import '../../../admin/controllers/settings_controller.dart';
import '../../../common/controllers/loading_controller.dart';
import '../../../submissions/controllers/submission_controller.dart';

class StudentSubmitPaperPage extends StatefulWidget {
  const StudentSubmitPaperPage({super.key});

  @override
  State<StudentSubmitPaperPage> createState() => _StudentSubmitPaperPageState();
}

class _StudentSubmitPaperPageState extends State<StudentSubmitPaperPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final _keywordController = TextEditingController();

  final List<String> _tags = [];
  final List<String> _keywords = [];

  String? _selectedDepartment;
  String? _selectedSubject;
  final List<String> _selectedSubjects = [];
  PaperFormat _selectedFormat = PaperFormat.pdf;
  PaperVisibility _selectedVisibility = PaperVisibility.public;
  bool _useTextSubmission = false;

  File? _selectedFile;
  Uint8List? _fileBytes;
  String? _fileName;

  final DepartmentController _departmentController = Get.find<DepartmentController>();
  final SettingsController _settingsController = Get.find<SettingsController>();
  final SubmissionController _submissionController = Get.find<SubmissionController>();
  final LoadingController _loadingController = Get.find<LoadingController>();

  bool get _isLoading => _loadingController.isLoading.value;

  @override
  void dispose() {
    _titleController.dispose();
    _abstractController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _keywordController.dispose();
    super.dispose();
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
    if (_selectedDepartment == null) {
      _showSnack('Please select a department.', AppColors.warning);
      return;
    }
    if (_selectedSubject == null) {
      _showSnack('Please select at least one subject.', AppColors.warning);
      return;
    }
    if (!_useTextSubmission && _selectedFile == null && _fileBytes == null) {
      _showSnack(
        'Please upload a manuscript or enable text submission.',
        AppColors.warning,
      );
      return;
    }

    try {
      final paper = await _loadingController.during(() {
        return _submissionController.submitPaper(
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
      });

      if (!mounted) return;
      _showSubmissionFeedback(paper);
      _resetForm();
    } catch (error) {
      _showSnack('Submission failed: $error', AppColors.error);
    }
  }

  void _showSubmissionFeedback(ResearchPaper paper) {
    switch (paper.status) {
      case PaperStatus.revisionsRequested:
        _showSnack(
          'AI review requested revisions. See the feedback dialog for details.',
          AppColors.warning,
        );
        final aiReview = paper.aiReview;
        if (aiReview != null) {
          _showAiFeedbackDialog(aiReview);
        }
        break;
      case PaperStatus.underReview:
        _showSnack(
          paper.primaryReviewerId != null
              ? 'AI approved your paper and it is now with a reviewer.'
              : 'AI approved your paper. Awaiting reviewer confirmation.',
          AppColors.success,
        );
        break;
      case PaperStatus.submitted:
        _showSnack(
          'AI approved your paper. Awaiting reviewer assignment.',
          AppColors.info,
        );
        break;
      case PaperStatus.aiReview:
        _showSnack(
          'Your paper is queued for AI review. This will complete shortly.',
          AppColors.indigo600,
        );
        break;
      default:
        _showSnack('Paper submitted successfully.', AppColors.success);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _abstractController.clear();
    _contentController.clear();
    _tagController.clear();
    _keywordController.clear();

    setState(() {
      _tags.clear();
      _keywords.clear();
      _selectedFile = null;
      _fileBytes = null;
      _fileName = null;
      _selectedSubject = null;
      _selectedVisibility = PaperVisibility.public;
      _selectedFormat = PaperFormat.pdf;
    });
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final departments = _departmentController.departments;
      final settings = _settingsController.settings.value;
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
              _DepartmentSelector(
                departments: departments,
                selectedDepartment: _selectedDepartment,
                selectedSubject: _selectedSubject,
                onDepartmentChanged: (value) => setState(() {
                  _selectedDepartment = value;
                  _selectedSubject = null;
                }),
                onSubjectChanged: (value) => setState(() {
                  _selectedSubject = value;
                  if (value != null && !_selectedSubjects.contains(value)) {
                    _selectedSubjects.add(value);
                  }
                }),
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
                onRemove: (value) => setState(() => _tags.remove(value)),
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
                onRemove: (value) => setState(() => _keywords.remove(value)),
              ),
              const SizedBox(height: 24),
              _AiInfoBanner(enabled: settings.aiPreReviewEnabled),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submit,
                    icon: const Icon(Icons.send_outlined),
                    label: Text(_isLoading ? 'Submitting...' : 'Submit for review'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DepartmentSelector extends StatelessWidget {
  const _DepartmentSelector({
    required this.departments,
    required this.selectedDepartment,
    required this.selectedSubject,
    required this.onDepartmentChanged,
    required this.onSubjectChanged,
  });

  final List<Department> departments;
  final String? selectedDepartment;
  final String? selectedSubject;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedDepartment,
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
          onChanged: onDepartmentChanged,
          validator: (value) => value == null ? 'Select a department' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedSubject,
          decoration: const InputDecoration(
            labelText: 'Subject',
            prefixIcon: Icon(Icons.menu_book_outlined),
          ),
          items: selectedDepartment == null
              ? const []
              : departments
                  .firstWhere((dept) => dept.id == selectedDepartment)
                  .subjects
                  .map(
                    (subject) => DropdownMenuItem(
                      value: subject.id,
                      child: Text(subject.name),
                    ),
                  )
                  .toList(),
          onChanged: onSubjectChanged,
          validator: (value) => value == null ? 'Select a subject' : null,
        ),
      ],
    );
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
        border: Border.all(color: enabled ? AppColors.lilac200 : AppColors.gray200),
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
                  ? 'Gemini pre-review will analyse your submission before a reviewer receives it.'
                  : 'AI pre-review is currently disabled. Your submission will go directly to the reviewer queue.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
