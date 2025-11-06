import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../../app/router.dart';
import '../../../core/constants/app_colors.dart';
import '../../common/controllers/loading_controller.dart';
import '../controllers/auth_controller.dart';
import '../domain/auth_role.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  AuthController get _authController => Get.find<AuthController>();
  LoadingController get _loadingController => Get.find<LoadingController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _authController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _openSignup(AuthRole role) {
    Get.toNamed(
      AppRoutes.signup,
      arguments: {'role': role.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return Row(
            children: [
              if (!isMobile) const _LoginHeroPanel(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in with your Kohinchha account.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 28),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: ValidationBuilder().email().build(),
                                  decoration: const InputDecoration(
                                    labelText: 'Institutional Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  validator: ValidationBuilder().minLength(6).build(),
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
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Forgot password?'),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _loadingController.isLoading.value ? null : _submit,
                                      child: const Text('Sign In'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: _loadingController.isLoading.value
                                          ? null
                                          : () => _openSignup(AuthRole.student),
                                      child: const Text('Create an account'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'Reviewer or Admin?',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.gray600),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _loadingController.isLoading.value
                                      ? null
                                      : () => _openSignup(AuthRole.reviewer),
                                  icon: const Icon(Icons.rate_review_outlined),
                                  label: const Text('Apply as Reviewer'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _loadingController.isLoading.value
                                      ? null
                                      : () => _openSignup(AuthRole.admin),
                                  icon: const Icon(Icons.admin_panel_settings_outlined),
                                  label: const Text('Admin Sign Up'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginHeroPanel extends StatelessWidget {
  const _LoginHeroPanel();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.indigoDeep, AppColors.indigo700, AppColors.violet500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kohinchha Research Network',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Securely collaborate, review, and publish research across departments.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  const Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _HighlightCard(
                        title: 'AI Review',
                        description: 'Automatic insights before peer review.',
                      ),
                      _HighlightCard(
                        title: 'Seamless Workflow',
                        description: 'Track submissions and feedback in real-time.',
                      ),
                      _HighlightCard(
                        title: 'Collaborative',
                        description: 'Connect with peers and participate in discussions.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
