import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/department.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/domain/auth_role.dart';
import '../../auth/providers/auth_controller.dart';
import '../../submissions/providers/submission_providers.dart';
import '../providers/admin_controller.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_settings_provider.dart';
import '../providers/department_providers.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final papersAsync = ref.watch(allPapersProvider);
    final pendingReviewersAsync = ref.watch(pendingReviewersProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform health overview', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Monitor submissions, reviewer workload, and AI review usage.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: 24),
          papersAsync.when(
            data: (papers) => pendingReviewersAsync.when(
              data: (pendingReviewers) => settingsAsync.when(
                data: (settings) {
                  final activeSubmissions =
                      papers.where((paper) => !paper.isPublished).length;
                  final aiUsage =
                      papers.where((paper) => paper.aiReview != null).length.toDouble();
                  final aiPercentage =
                      papers.isEmpty ? 0 : (aiUsage / papers.length * 100).round();

                  return Wrap(
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
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Unable to load settings: $error'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Unable to load reviewers: $error'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Unable to load submissions: $error'),
          ),
        ],
      ),
    );
  }
}

class AdminDepartmentsPage extends ConsumerWidget {
  const AdminDepartmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final controller = ref.watch(adminControllerProvider);
    final nameController = TextEditingController();
    final subjectController = TextEditingController();
    final subjects = <String>[];

    Future<void> showAddDialog() async {
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
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final value = subjectController.text.trim();
                              if (value.isEmpty) return;
                              setState(() {
                                subjects.add(value);
                              });
                              subjectController.clear();
                            },
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
                  await controller.addDepartment(
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
                onPressed: showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add department'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          departmentsAsync.when(
            data: (departments) => Column(
              children: departments
                  .map(
                    (department) => _DepartmentCard(
                      department: department,
                    ),
                  )
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Unable to load departments: $error'),
          ),
        ],
      ),
    );
  }
}

class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final controller = ref.watch(adminControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: usersAsync.when(
        data: (users) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: users.map((user) {
            return _UserRow(
              user: user,
              onApprove: (approved) =>
                  controller.approveReviewer(reviewerId: user.id, approved: approved),
              onBlock: (block) => controller.blockUser(userId: user.id, block: block),
            );
          }).toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Unable to load users: $error'),
      ),
    );
  }
}

class AdminPapersPage extends ConsumerStatefulWidget {
  const AdminPapersPage({super.key});

  @override
  ConsumerState<AdminPapersPage> createState() => _AdminPapersPageState();
}

class _AdminPapersPageState extends ConsumerState<AdminPapersPage> {
  final _reassignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final papersAsync = ref.watch(allPapersProvider);
    final adminController = ref.watch(adminControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: papersAsync.when(
        data: (papers) => Column(
          children: papers.map((paper) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              margin: const EdgeInsets.only(bottom: 16),
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
                      controller: _reassignController,
                      decoration: InputDecoration(
                        labelText: 'Assign reviewer by ID',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () async {
                            final reviewerId = _reassignController.text.trim();
                            if (reviewerId.isEmpty) return;
                            await adminController.reassignReviewer(
                              paperId: paper.id,
                              reviewerId: reviewerId,
                            );
                            if (mounted) {
                              _reassignController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reassigned to $reviewerId')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Unable to load papers: $error'),
      ),
    );
  }
}

class AdminSettingsPage extends ConsumerWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final controller = ref.watch(adminControllerProvider);

    return settingsAsync.when(
      data: (settings) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('System settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: settings.aiPreReviewEnabled,
              onChanged: (value) => controller.updateSettings(
                settings.copyWith(aiPreReviewEnabled: value),
              ),
              title: const Text('Enable AI pre-review'),
              subtitle: const Text('Route submissions to Gemini before human reviewers.'),
            ),
            SwitchListTile.adaptive(
              value: settings.allowStudentRegistration,
              onChanged: (value) => controller.updateSettings(
                settings.copyWith(allowStudentRegistration: value),
              ),
              title: const Text('Allow student registration'),
            ),
            SwitchListTile.adaptive(
              value: settings.allowReviewerRegistration,
              onChanged: (value) => controller.updateSettings(
                settings.copyWith(allowReviewerRegistration: value),
              ),
              title: const Text('Allow reviewer applications'),
            ),
            SwitchListTile.adaptive(
              value: settings.allowPublicVisibility,
              onChanged: (value) => controller.updateSettings(
                settings.copyWith(allowPublicVisibility: value),
              ),
              title: const Text('Allow public visibility'),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Unable to load settings: $error'),
    );
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

class _DepartmentCard extends ConsumerWidget {
  const _DepartmentCard({required this.department});

  final Department department;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(adminControllerProvider);
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
                  onChanged: (value) => controller.toggleDepartment(
                    departmentId: department.id,
                    isActive: value,
                  ),
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
                      onDeleted: () => controller.removeSubject(
                        department: department,
                        subject: subject,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () async {
                final subjectName = await showDialog<String>(
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
                          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
                if (subjectName != null && subjectName.isNotEmpty) {
                  ref.read(adminControllerProvider).addSubject(
                        departmentId: department.id,
                        subjectName: subjectName,
                      );
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
