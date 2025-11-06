import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/app_user.dart';
import '../../../admin/providers/department_providers.dart';
import '../../../auth/providers/auth_controller.dart';

class StudentSettingsPage extends ConsumerStatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  ConsumerState<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends ConsumerState<StudentSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _departmentId;
  List<String> _subjectIds = [];
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentAppUserProvider);
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
    final user = ref.watch(currentAppUserProvider);
    final departmentsAsync = ref.watch(departmentsProvider);
    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account settings', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Update your profile information, expertise preferences, and notification settings.',
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
                  departmentsAsync.when(
                    data: (departments) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            _subjectIds = [];
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
                    loading: () => const LinearProgressIndicator(),
                    error: (error, _) => Text('Unable to load departments: $error'),
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
                onPressed: () async {
                  final updated = user.copyWith(
                    displayName: _nameController.text.trim(),
                    bio: _bioController.text.trim(),
                    departmentId: _departmentId,
                    subjectIds: _subjectIds,
                  );
                  await ref.read(authControllerProvider.notifier).updateProfile(updated);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated')),
                  );
                },
                child: const Text('Save changes'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
