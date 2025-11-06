import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/research_paper.dart';
import '../../../admin/controllers/department_controller.dart';
import '../../../submissions/controllers/submission_controller.dart';

class StudentTrendingPage extends StatefulWidget {
  const StudentTrendingPage({super.key});

  @override
  State<StudentTrendingPage> createState() => _StudentTrendingPageState();
}

class _StudentTrendingPageState extends State<StudentTrendingPage> {
  final SubmissionController _submissionController = Get.find<SubmissionController>();
  final DepartmentController _departmentController = Get.find<DepartmentController>();

  String? _departmentFilter;
  String? _subjectFilter;
  PaperVisibility? _visibilityFilter = PaperVisibility.public;
  DateTime? _afterDateFilter;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final departments = _departmentController.departments;
      final papers = _submissionController.publishedPapers;

      final filtered = papers.where((paper) {
        final departmentMatches =
            _departmentFilter == null || paper.departmentId == _departmentFilter;
        final subjectMatches = _subjectFilter == null || paper.subjectId == _subjectFilter;
        final visibilityMatches =
            _visibilityFilter == null || paper.visibility == _visibilityFilter;
        final dateMatches =
            _afterDateFilter == null || (paper.publishedAt ?? DateTime(0)).isAfter(_afterDateFilter!);
        return departmentMatches && subjectMatches && visibilityMatches && dateMatches;
      }).toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trending research', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Discover research shared publicly or with your connections. Use filters to narrow topics.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
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
                        (dept) => DropdownMenuItem(
                          value: dept.id,
                          child: Text(dept.name),
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
                            .firstWhere((dept) => dept.id == _departmentFilter)
                            .subjects
                            .map(
                              (subject) => DropdownMenuItem(
                                value: subject.id,
                                child: Text(subject.name),
                              ),
                            ),
                    ],
                    onChanged: (value) => setState(() => _subjectFilter = value),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<PaperVisibility>(
                    value: _visibilityFilter,
                    decoration: const InputDecoration(
                      labelText: 'Visibility',
                      prefixIcon: Icon(Icons.visibility_outlined),
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
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<DateTime>(
                    value: _afterDateFilter,
                    decoration: const InputDecoration(
                      labelText: 'Published after',
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Any time')),
                      DropdownMenuItem(
                        value: DateTime.now().subtract(const Duration(days: 7)),
                        child: const Text('Last 7 days'),
                      ),
                      DropdownMenuItem(
                        value: DateTime.now().subtract(const Duration(days: 30)),
                        child: const Text('Last 30 days'),
                      ),
                      DropdownMenuItem(
                        value: DateTime.now().subtract(const Duration(days: 180)),
                        child: const Text('Last 6 months'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _afterDateFilter = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (filtered.isEmpty)
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
                        'No papers match the selected filters.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: filtered.map((paper) => _TrendingCard(paper: paper)).toList(),
              ),
          ],
        ),
      );
    });
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.paper});

  final ResearchPaper paper;

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.workspace_premium_outlined, color: AppColors.indigo600),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    paper.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text(paper.visibility.label),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              paper.abstractText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Department: ${paper.departmentId}')),
                Chip(label: Text('Subject: ${paper.subjectId}')),
                Chip(label: Text('Keywords: ${paper.keywords.join(', ')}')),
              ],
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
                      'AI Insights (Gemini)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      paper.aiReview!.summary,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.gray600),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
