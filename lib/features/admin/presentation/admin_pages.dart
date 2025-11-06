import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  SubmissionController get _submissionController => Get.find<SubmissionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final papers = _submissionController.studentPapers;
      final reviewerController = TextEditingController();
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: papers.length,
        itemBuilder: (context, index) {
          final paper = papers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paper.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Owner: ${paper.ownerId} • Status: ${paper.status.label}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray500,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reviewerController,
                    decoration: InputDecoration(
                      labelText: 'Assign reviewer by ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () async {
                          final reviewerId = reviewerController.text.trim();
                          if (reviewerId.isEmpty) return;
                          await _adminController.reassignReviewer(
                            paperId: paper.id,
                            reviewerId: reviewerId,
                          );
                          reviewerController.clear();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reassigned to $reviewerId')),
                          );
                        },
                      ),
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
