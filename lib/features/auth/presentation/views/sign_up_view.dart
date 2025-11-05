import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/department.dart';
import '../../../../core/models/user_role.dart';
import '../../domain/auth_controller.dart';
import '../../../shared/domain/department_providers.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole _role = UserRole.student;
  String? _selectedDepartmentId;
  final Set<String> _selectedSubjects = {};
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(List<Department> departments) async {
    if (!_formKey.currentState!.validate()) return;

    final department = departments.firstWhere(
      (dept) => dept.id == _selectedDepartmentId,
      orElse: () => Department(id: '', name: '', subjects: const []),
    );

    final departmentName = _role.isAdmin || department.id.isEmpty
        ? null
        : department.name;

    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _role,
          department: departmentName,
          subjects: _role.isReviewer ? _selectedSubjects.toList() : const [],
        );
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.listen inside build (WidgetRef) to avoid Riverpod assertion when
    // registering listeners outside of the ConsumerWidget build phase.
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.hasError != true && next.hasError) {
        final message = next.error?.toString() ?? 'Sign up failed.';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        });
      }
    });

    final departmentsAsync = ref.watch(departmentsStreamProvider);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final departments = departmentsAsync.value ?? [];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          final form = Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join ResearchHub',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                SegmentedButton<UserRole>(
                  segments: const [
                    ButtonSegment(
                      value: UserRole.student,
                      label: Text('Student'),
                    ),
                    ButtonSegment(
                      value: UserRole.reviewer,
                      label: Text('Reviewer'),
                    ),
                    ButtonSegment(
                      value: UserRole.admin,
                      label: Text('Admin'),
                    ),
                  ],
                  selected: <UserRole>{_role},
                  onSelectionChanged: (roles) {
                    setState(() {
                      _role = roles.first;
                      if (_role.isAdmin) {
                        _selectedDepartmentId = null;
                        _selectedSubjects.clear();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_role.isReviewer)
                  const Text(
                    'Reviewer accounts require admin approval before accessing submissions.',
                  ),
                if (_role.isAdmin)
                  const Text(
                    'Admin requests require verification from an active administrator. '
                    'First admin must be approved manually via Firebase.',
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Min 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            }),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirmation required';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_role.isAdmin) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedDepartmentId,
                    items: departments
                        .map(
                          (dept) => DropdownMenuItem(
                            value: dept.id,
                            child: Text(dept.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedDepartmentId = value;
                      _selectedSubjects.clear();
                    }),
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_role.isReviewer || _role.isStudent) {
                        if (value == null || value.isEmpty) {
                          return 'Department is required';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (_role.isReviewer)
                  _ReviewerSubjectsSelector(
                    subjects: departments
                        .firstWhere(
                          (dept) => dept.id == _selectedDepartmentId,
                          orElse: () =>
                              Department(id: '', name: '', subjects: const []),
                        )
                        .subjects,
                    selected: _selectedSubjects,
                    onChanged: (value) => setState(() {
                      if (_selectedSubjects.contains(value)) {
                        _selectedSubjects.remove(value);
                      } else {
                        _selectedSubjects.add(value);
                      }
                    }),
                  ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () => _handleSubmit(departments),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/auth/sign-in'),
                  child: const Text('Already registered? Sign in'),
                ),
              ],
            ),
          );

          if (isWide) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ResearchHub',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Collaborate, review, and publish research with a streamlined workflow.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: form,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(padding: const EdgeInsets.all(32), child: form),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewerSubjectsSelector extends StatelessWidget {
  const _ReviewerSubjectsSelector({
    required this.subjects,
    required this.selected,
    required this.onChanged,
  });

  final List<String> subjects;
  final Set<String> selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const Text('No subjects configured for this department yet.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subjects you can review'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subjects
              .map(
                (subject) => FilterChip(
                  label: Text(subject),
                  selected: selected.contains(subject),
                  onSelected: (_) => onChanged(subject),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
