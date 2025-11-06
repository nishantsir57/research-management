import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../admin/controllers/department_controller.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../common/controllers/loading_controller.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _departmentId;
  List<String> _subjectIds = [];
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;

  final AuthController _authController = Get.find<AuthController>();
  final DepartmentController _departmentController = Get.find<DepartmentController>();
  final LoadingController _loadingController = Get.find<LoadingController>();

  @override
  void initState() {
    super.initState();
    final user = _authController.currentUser.value;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _departmentId = user?.departmentId;
    _subjectIds = [...?user?.subjectIds];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _authController.currentUser.value;
      if (user == null) {
        return const Center(child: Text('Sign in to view settings.'));
      }
      final departments = _departmentController.departments;
      final isLoading = _loadingController.isLoading.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Manage privacy, visibility, and profile preferences.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Academic preferences', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _departmentId,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      items: departments
                          .map(
                            (department) => DropdownMenuItem(
                              value: department.id,
                              child: Text(department.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _departmentId = value;
                        _subjectIds.clear();
                      }),
                    ),
                    const SizedBox(height: 12),
                    if (_departmentId != null)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: departments
                            .firstWhere((department) => department.id == _departmentId)
                            .subjects
                            .map(
                              (subject) => FilterChip(
                                label: Text(subject.name),
                                selected: _subjectIds.contains(subject.id),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _subjectIds.add(subject.id);
                                    } else {
                                      _subjectIds.remove(subject.id);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
                    SwitchListTile(
                      value: _notificationsEnabled,
                      onChanged: (value) => setState(() => _notificationsEnabled = value),
                      title: const Text('Push notifications'),
                      subtitle: const Text('Get notified about review updates and comments.'),
                    ),
                    SwitchListTile(
                      value: _emailUpdates,
                      onChanged: (value) => setState(() => _emailUpdates = value),
                      title: const Text('Email updates'),
                      subtitle: const Text('Receive weekly digest about trending research.'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final updated = user.copyWith(
                            displayName: _nameController.text.trim(),
                            bio: _bioController.text.trim(),
                            departmentId: _departmentId,
                            subjectIds: _subjectIds,
                          );
                          await _loadingController.during(
                            () => _authController.updateProfile(updated),
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );
                        },
                  child: Text(isLoading ? 'Saving...' : 'Save changes'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => _authController.signOut(),
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
