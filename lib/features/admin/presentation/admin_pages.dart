import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/department.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/domain/auth_role.dart';
import '../../submissions/controllers/submission_controller.dart';
import '../controllers/admin_controller.dart';
import '../controllers/department_controller.dart';
import '../controllers/settings_controller.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  AdminController get _adminController => Get.find<AdminController>();
  SubmissionController get _submissionController => Get.find<SubmissionController>();
  SettingsController get _settingsController => Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final papers = _submissionController.studentPapers;
      final pendingReviewers = _adminController.pendingReviewers;
      final settings = _settingsController.settings.value;

      final activeSubmissions =
          papers.where((paper) => !paper.isPublished && paper.status != PaperStatus.draft).length;
      final aiUsage = papers.where((paper) => paper.aiReview != null).length;
      final aiPercentage = papers.isEmpty ? 0 : (aiUsage / papers.length * 100).round();

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _AdminStatCard(
              icon: Icons.library_books_outlined,
              title: 'Active submissions',
              value: '$activeSubmissions',
              detail: 'Awaiting reviewer decisions',
            ),
            _AdminStatCard(
              icon: Icons.person_search_outlined,
              title: 'Reviewers pending approval',
              value: '${pendingReviewers.length}',
              detail: 'Applications awaiting admin action',
            ),
            _AdminStatCard(
              icon: Icons.auto_awesome_outlined,
              title: 'AI review usage',
              value: '$aiPercentage%',
              detail: settings.aiPreReviewEnabled
                  ? 'Gemini pre-screening enabled'
                  : 'AI pre-review disabled',
            ),
          ],
        ),
      );
    });
  }
}

class AdminDepartmentsPage extends StatelessWidget {
  const AdminDepartmentsPage({super.key});

  DepartmentController get _departmentController => Get.find<DepartmentController>();
  AdminController get _adminController => Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final departments = _departmentController.departments;
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manage departments', style: Theme.of(context).textTheme.headlineMedium),
                ElevatedButton.icon(
                  onPressed: () => _showAddDepartmentDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add department'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (departments.isEmpty)
              const Text('No departments found.')
            else
              Column(
                children: departments
                    .map(
                      (department) => _DepartmentCard(
                        department: department,
                        onToggle: (value) => _adminController.toggleDepartment(
                          departmentId: department.id,
                          isActive: value,
                        ),
                        onRemoveSubject: (subject) =>
                            _adminController.removeSubject(department: department, subject: subject),
                        onAddSubject: (name) =>
                            _adminController.addSubject(departmentId: department.id, subjectName: name),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      );
    });
  }

  Future<void> _showAddDepartmentDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final subjectController = TextEditingController();
    final subjects = <String>[];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add department'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Department name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        suffixIcon: IconButton(
                          onPressed: () {
                            final text = subjectController.text.trim();
                            if (text.isEmpty) return;
                            setState(() {
                              subjects.add(text);
                            });
                            subjectController.clear();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: subjects
                          .map(
                            (subject) => Chip(
                              label: Text(subject),
                              onDeleted: () => setState(() => subjects.remove(subject)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                await _adminController.addDepartment(
                  name: nameController.text.trim(),
                  subjects: subjects,
                );
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  AdminController get _adminController => Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = _adminController.allUsers;
      if (users.isEmpty) {
        return const Center(child: Text('No users found.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _UserRow(
            user: user,
            onApprove: (approved) =>
                _adminController.approveReviewer(reviewerId: user.id, approved: approved),
            onBlock: (block) => _adminController.blockUser(userId: user.id, block: block),
          );
        },
      );
    });
  }
}

class AdminPapersPage extends StatelessWidget {
  const AdminPapersPage({super.key});

  AdminController get _adminController => Get.find<AdminController>();
  DepartmentController get _departmentController => Get.find<DepartmentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final papers = _adminController.allPapers;
      final users = _adminController.allUsers;
      final departments = _departmentController.departments;

      if (papers.isEmpty) {
        return const Center(child: Text('No submissions yet.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: papers.length,
        itemBuilder: (context, index) {
          final paper = papers[index];
          final owner =
              users.firstWhereOrNull((user) => user.id == paper.ownerId)?.displayName ??
                  paper.ownerId;
          final primaryReviewer = paper.primaryReviewerId != null
              ? users.firstWhereOrNull((user) => user.id == paper.primaryReviewerId)?.displayName ??
                  paper.primaryReviewerId!
              : 'Unassigned';
          final departmentName = departments
                  .firstWhereOrNull((dept) => dept.id == paper.departmentId)
                  ?.name ??
              paper.departmentId;
          final statusColor = _statusColor(paper.status);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                        label: Text(paper.status.label),
                        backgroundColor: statusColor.withValues(alpha: 0.12),
                        labelStyle: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.person_outline,
                    label: 'Student',
                    value: owner,
                  ),
                  _InfoRow(
                    icon: Icons.account_tree_outlined,
                    label: 'Department',
                    value: departmentName,
                  ),
                  _InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Primary reviewer',
                    value: primaryReviewer,
                  ),
                  if (paper.aiReview != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _AiSummaryChip(paper: paper),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.manage_accounts_outlined),
                          label: const Text('Reassign reviewer'),
                          onPressed: () => _showReassignSheet(context, paper),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('View details'),
                          onPressed: () => Get.toNamed(
                            '${AppRoutes.paperDetail}/${paper.id}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _showReassignSheet(BuildContext context, ResearchPaper paper) async {
    final reviewers = _adminController.allUsers
        .where(
          (user) =>
              user.isReviewer &&
              user.isReviewerApproved &&
              !user.isBlocked &&
              user.departmentId == paper.departmentId,
        )
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    if (reviewers.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No approved reviewers found for this department.')),
        );
      }
      return;
    }

    await showModalBottomSheet<AppUser>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final searchController = TextEditingController();
        AppUser? selected;
        return StatefulBuilder(
          builder: (context, setState) {
            final query = searchController.text.trim().toLowerCase();
            final filtered = reviewers.where((reviewer) {
              if (query.isEmpty) return true;
              return reviewer.displayName.toLowerCase().contains(query) ||
                  reviewer.email.toLowerCase().contains(query);
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reassign reviewer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search reviewers',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: filtered.isEmpty
                        ? const Center(child: Text('No reviewers match the search.'))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final reviewer = filtered[index];
                              final isSelected = selected?.id == reviewer.id;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.indigo600,
                                  child: Text(
                                    reviewer.displayName.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(reviewer.displayName),
                                subtitle: Text(reviewer.email),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: AppColors.indigo600)
                                    : null,
                                onTap: () => setState(() => selected = reviewer),
                              );
                            },
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemCount: filtered.length,
                          ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selected == null
                          ? null
                          : () async {
                              try {
                                await _adminController.reassignReviewer(
                                  paperId: paper.id,
                                  reviewerId: selected!.id,
                                );
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Assigned to ${selected!.displayName}.'),
                                  ),
                                );
                              } catch (error) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$error')),
                                  );
                                }
                              }
                            },
                      child: const Text('Assign reviewer'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(PaperStatus status) {
    switch (status) {
      case PaperStatus.submitted:
      case PaperStatus.aiReview:
      case PaperStatus.underReview:
        return AppColors.indigo600;
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
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gray500),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiSummaryChip extends StatelessWidget {
  const _AiSummaryChip({required this.paper});

  final ResearchPaper paper;

  @override
  Widget build(BuildContext context) {
    final aiReview = paper.aiReview;
    if (aiReview == null) return const SizedBox.shrink();
    final passed = paper.status != PaperStatus.revisionsRequested;
    final color = passed ? AppColors.success : AppColors.warning;
    final label = passed ? 'AI pre-review passed' : 'AI requested changes';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.12),
      ),
      child: Row(
        children: [
          Icon(
            passed ? Icons.auto_awesome_outlined : Icons.error_outline,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label • Quality ${(aiReview.qualityScore).toStringAsFixed(1)}, '
              'Plagiarism ${(aiReview.plagiarismRisk).toStringAsFixed(1)}%',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  SettingsController get _settingsController => Get.find<SettingsController>();
  AdminController get _adminController => Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = _settingsController.settings.value;
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('System settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: settings.aiPreReviewEnabled,
            onChanged: (value) =>
                _adminController.updateSettings(settings.copyWith(aiPreReviewEnabled: value)),
            title: const Text('Enable AI pre-review'),
            subtitle: const Text('Route submissions to Gemini before human reviewers.'),
          ),
          SwitchListTile.adaptive(
            value: settings.allowStudentRegistration,
            onChanged: (value) =>
                _adminController.updateSettings(settings.copyWith(allowStudentRegistration: value)),
            title: const Text('Allow student registration'),
          ),
          SwitchListTile.adaptive(
            value: settings.allowReviewerRegistration,
            onChanged: (value) =>
                _adminController.updateSettings(settings.copyWith(allowReviewerRegistration: value)),
            title: const Text('Allow reviewer applications'),
          ),
          SwitchListTile.adaptive(
            value: settings.allowPublicVisibility,
            onChanged: (value) =>
                _adminController.updateSettings(settings.copyWith(allowPublicVisibility: value)),
            title: const Text('Allow public visibility'),
          ),
        ],
      );
    });
  }
}

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.indigo600),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.indigo700, fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}

class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({
    required this.department,
    required this.onToggle,
    required this.onRemoveSubject,
    required this.onAddSubject,
  });

  final Department department;
  final ValueChanged<bool> onToggle;
  final ValueChanged<Subject> onRemoveSubject;
  final ValueChanged<String> onAddSubject;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(department.name, style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: department.isActive,
                  onChanged: onToggle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: department.subjects
                  .map(
                    (subject) => Chip(
                      label: Text(subject.name),
                      onDeleted: () => onRemoveSubject(subject),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () async {
                final name = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController();
                    return AlertDialog(
                      title: const Text('Add subject'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: 'Subject name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(controller.text.trim()),
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
                if (name != null && name.isNotEmpty) {
                  onAddSubject(name);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add subject'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.onApprove,
    required this.onBlock,
  });

  final AppUser user;
  final ValueChanged<bool> onApprove;
  final ValueChanged<bool> onBlock;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.indigo600,
          child: Text(
            user.displayName.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.displayName),
        subtitle: Text('${user.email} • ${user.role.label}'),
        trailing: Wrap(
          spacing: 8,
          children: [
            if (user.role == AuthRole.reviewer)
              Switch(
                value: user.isReviewerApproved,
                onChanged: onApprove,
              ),
            Switch(
              value: user.isBlocked,
              onChanged: onBlock,
            ),
          ],
        ),
      ),
    );
  }
}
