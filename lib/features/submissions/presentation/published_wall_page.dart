import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/research_paper.dart';
import '../../admin/controllers/department_controller.dart';
import '../../common/controllers/user_directory_controller.dart';
import '../controllers/submission_controller.dart';

class PublishedWallPage extends StatefulWidget {
  const PublishedWallPage({
    super.key,
    this.title = 'Published research',
    this.subtitle =
        'Browse the latest verified publications across Kohinchha. Join the discussion or review the full paper.',
  });

  final String title;
  final String subtitle;

  @override
  State<PublishedWallPage> createState() => _PublishedWallPageState();
}

class _PublishedWallPageState extends State<PublishedWallPage> {
  final SubmissionController _submissionController = Get.find<SubmissionController>();
  final DepartmentController _departmentController = Get.find<DepartmentController>();
  final UserDirectoryController _userDirectoryController =
      Get.find<UserDirectoryController>();

  String? _departmentFilter;
  String? _subjectFilter;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final departments = _departmentController.departments;
      final papers = _submissionController.publishedPapers.where((paper) {
        final departmentMatches =
            _departmentFilter == null || paper.departmentId == _departmentFilter;
        final subjectMatches = _subjectFilter == null || paper.subjectId == _subjectFilter;
        return departmentMatches && subjectMatches;
      }).toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray600,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    value: _departmentFilter,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All departments')),
                      ...departments.map(
                        (department) => DropdownMenuItem(
                          value: department.id,
                          child: Text(department.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _departmentFilter = value;
                      _subjectFilter = null;
                    }),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    value: _subjectFilter,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All subjects')),
                      if (_departmentFilter != null)
                        ...departments
                            .firstWhereOrNull((dept) => dept.id == _departmentFilter)
                            ?.subjects
                            .map(
                              (subject) => DropdownMenuItem(
                                value: subject.id,
                                child: Text(subject.name),
                              ),
                            )
                            .toList() ??
                            const [],
                    ],
                    onChanged: (value) => setState(() => _subjectFilter = value),
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
                        'No published papers match the current filters.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: papers
                    .map(
                      (paper) => _PublishedCard(
                        paper: paper,
                        ownerName: _userName(paper.ownerId),
                        departmentName: _departmentName(paper.departmentId),
                        subjectName: _subjectName(paper.departmentId, paper.subjectId),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      );
    });
  }

  String _userName(String userId) {
    return _userDirectoryController.users
            .firstWhereOrNull((user) => user.id == userId)
            ?.displayName ??
        userId;
  }

  String _departmentName(String departmentId) {
    return _departmentController.departments
            .firstWhereOrNull((dept) => dept.id == departmentId)
            ?.name ??
        departmentId;
  }

  String _subjectName(String departmentId, String subjectId) {
    final department = _departmentController.departments
        .firstWhereOrNull((dept) => dept.id == departmentId);
    if (department == null) return subjectId;
    return department.subjects
            .firstWhereOrNull((subject) => subject.id == subjectId)
            ?.name ??
        subjectId;
  }
}

class _PublishedCard extends StatelessWidget {
  const _PublishedCard({
    required this.paper,
    required this.ownerName,
    required this.departmentName,
    required this.subjectName,
  });

  final ResearchPaper paper;
  final String ownerName;
  final String departmentName;
  final String subjectName;

  @override
  Widget build(BuildContext context) {
    final publishedDate = paper.publishedAt ?? paper.updatedAt ?? paper.submittedAt;
    final publishedLabel = publishedDate != null
        ? '${publishedDate.day}/${publishedDate.month}/${publishedDate.year}'
        : 'Not dated';

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
            Text(
              paper.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              paper.abstractText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.person_outline, size: 18),
                  label: Text(ownerName),
                ),
                Chip(
                  avatar: const Icon(Icons.school_outlined, size: 18),
                  label: Text(departmentName),
                ),
                Chip(
                  avatar: const Icon(Icons.menu_book_outlined, size: 18),
                  label: Text(subjectName),
                ),
                Chip(
                  avatar: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text('Published $publishedLabel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
