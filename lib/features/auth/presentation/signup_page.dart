import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/department.dart';
import '../../admin/providers/department_providers.dart';
import '../../common/providers/loading_provider.dart';
import '../domain/auth_role.dart';
import '../providers/auth_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key, this.initialRole});

  final AuthRole? initialRole;

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otherDepartmentController = TextEditingController();
  final _otherSubjectController = TextEditingController();

  AuthRole _selectedRole = AuthRole.student;
  String? _selectedDepartment;
  String? _selectedSubject;
  final List<String> _selectedSubjects = [];
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialRole != null) {
      _selectedRole = widget.initialRole!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otherDepartmentController.dispose();
    _otherSubjectController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms to continue.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final loading = ref.read(globalLoadingProvider.notifier);
    final controller = ref.read(authControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    await loading.during(() async {
      try {
        await controller.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
          role: _selectedRole,
          departmentId: _selectedDepartment == 'other' ? null : _selectedDepartment,
          subjectIds: _selectedSubjects.isEmpty ? null : _selectedSubjects,
        );
      } catch (error) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Registration failed: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Kohinchha Account'),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Already have an account? Sign in'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join the Kohinchha network',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Create an account tailored to your role. All signups are verified by the admin team.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColors.gray600),
                          ),
                          const SizedBox(height: 28),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: AuthRole.values.map((role) {
                              final isActive = _selectedRole == role;
                              return ChoiceChip(
                                label: Text(role.label),
                                selected: isActive,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedRole = role;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          GridView.count(
                            crossAxisCount: isMobile ? 1 : 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: isMobile ? 1.6 : 1.9,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                validator: ValidationBuilder().minLength(3).build(),
                                decoration: const InputDecoration(
                                  labelText: 'Full name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: ValidationBuilder()
                                    .email()
                                    .regExp(
                                      RegExp(r'.+@.+\..+'),
                                      'Enter a valid institutional email',
                                    )
                                    .build(),
                                decoration: const InputDecoration(
                                  labelText: 'Institutional email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: ValidationBuilder().minLength(8).build(),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Confirm password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                                    ),
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          departmentsAsync.when(
                            data: (departments) => _DepartmentSection(
                              departments: departments,
                              selectedRole: _selectedRole,
                              selectedDepartment: _selectedDepartment,
                              selectedSubjects: _selectedSubjects,
                              selectedSubject: _selectedSubject,
                              onDepartmentChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                  if (value != _selectedDepartment) {
                                    _selectedSubjects.clear();
                                  }
                                });
                              },
                              onSubjectChanged: (value) {
                                setState(() => _selectedSubject = value);
                              },
                              onAddSubject: () {
                                if (_selectedSubject == null || _selectedSubject!.isEmpty) return;
                                setState(() {
                                  if (!_selectedSubjects.contains(_selectedSubject)) {
                                    _selectedSubjects.add(_selectedSubject!);
                                  }
                                  _selectedSubject = null;
                                });
                              },
                              onRemoveSubject: (subject) {
                                setState(() => _selectedSubjects.remove(subject));
                              },
                              otherDepartmentController: _otherDepartmentController,
                              otherSubjectController: _otherSubjectController,
                            ),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Failed to load departments: $error',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CheckboxListTile(
                            value: _agreedToTerms,
                            onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                            title: const Text(
                              'I agree to follow Kohinchha community guidelines and institutional policies.',
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              child: const Text('Create account'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DepartmentSection extends StatelessWidget {
  const _DepartmentSection({
    required this.departments,
    required this.selectedRole,
    required this.selectedDepartment,
    required this.selectedSubjects,
    required this.selectedSubject,
    required this.onDepartmentChanged,
    required this.onSubjectChanged,
    required this.onAddSubject,
    required this.onRemoveSubject,
    required this.otherDepartmentController,
    required this.otherSubjectController,
  });

  final List<Department> departments;
  final AuthRole selectedRole;
  final String? selectedDepartment;
  final List<String> selectedSubjects;
  final String? selectedSubject;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onSubjectChanged;
  final VoidCallback onAddSubject;
  final ValueChanged<String> onRemoveSubject;
  final TextEditingController otherDepartmentController;
  final TextEditingController otherSubjectController;

  @override
  Widget build(BuildContext context) {
    final needsDepartment = selectedRole != AuthRole.admin;
    if (!needsDepartment) {
      return const SizedBox.shrink();
    }
    final otherDepartmentSelected = selectedDepartment == 'other';
    final selectedDept = departments.firstWhereOrNull((dept) => dept.id == selectedDepartment);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Academic context',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: selectedDepartment,
          decoration: const InputDecoration(
            labelText: 'Department',
            prefixIcon: Icon(Icons.school_outlined),
          ),
          items: [
            ...departments.map(
              (department) => DropdownMenuItem(
                value: department.id,
                child: Text(department.name),
              ),
            ),
            const DropdownMenuItem(
              value: 'other',
              child: Text('Other'),
            ),
          ],
          onChanged: onDepartmentChanged,
        ),
        if (otherDepartmentSelected)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              controller: otherDepartmentController,
              decoration: const InputDecoration(
                labelText: 'Specify other department',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
          ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedSubject,
          decoration: const InputDecoration(
            labelText: 'Primary subject',
            prefixIcon: Icon(Icons.menu_book_outlined),
          ),
          items: [
            if (selectedDept != null)
              ...selectedDept.subjects.map(
                (subject) => DropdownMenuItem(
                  value: subject.id,
                  child: Text(subject.name),
                ),
              ),
            const DropdownMenuItem(
              value: 'other',
              child: Text('Other'),
            ),
          ],
          onChanged: onSubjectChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: otherSubjectController,
                decoration: const InputDecoration(
                  labelText: 'Add additional subject or keywords',
                  prefixIcon: Icon(Icons.add_outlined),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                final text = otherSubjectController.text.trim();
                if (text.isEmpty) return;
                onSubjectChanged(text);
                otherSubjectController.clear();
                onAddSubject();
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedSubjects
              .map(
                (subject) => Chip(
                  label: Text(subject),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => onRemoveSubject(subject),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
