import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.indigoDeep, AppColors.indigo700, AppColors.violet500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 64,
                    vertical: isMobile ? 24 : 48,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: Card(
                      elevation: 0,
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 24 : 48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isMobile)
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: OutlinedButton(
                                    onPressed: onGetStarted,
                                    child: const Text('Get Started'),
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 8,
                                        children: const [
                                          _Pill(text: 'Collaborative Research'),
                                          _Pill(text: 'AI Assisted Reviews'),
                                          _Pill(text: 'Secure Storage'),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        'Kohinchha Research Network',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(color: AppColors.indigo700),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        'Your unified workspace for managing research submissions, '
                                        'peer reviews, and scholarly collaborations across departments.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(color: AppColors.gray600, height: 1.6),
                                      ),
                                      const SizedBox(height: 32),
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: onGetStarted,
                                            icon: const Icon(Icons.login_rounded),
                                            label: const Text('Join Kohinchha'),
                                          ),
                                          OutlinedButton.icon(
                                            onPressed: () {},
                                            icon: const Icon(Icons.play_circle_outline),
                                            label: const Text('Watch Demo'),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 0),
                                      // _FeatureList(isMobile: isMobile),
                                    ],
                                  ),
                                ),
                                if (!isMobile) const SizedBox(width: 48),
                                if (!isMobile)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(28),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFF5F3FF),
                                                  Color(0xFFE0E7FF),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 24,
                                                  left: 24,
                                                  right: 24,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Trusted by universities and research labs',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color: AppColors.indigo700,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 24),
                                                      _StatsCard(
                                                        title: '12K+',
                                                        subtitle: 'Active Researchers',
                                                      ),
                                                      const SizedBox(height: 16),
                                                      _StatsCard(
                                                        title: '2.4K',
                                                        subtitle: 'Published Papers',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        Text(
                                          'Accelerate peer review with smart AI verification before human review, '
                                          'ensuring integrity and rapid feedback.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(color: AppColors.gray600),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 30, 27, 75),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: AppColors.indigo700, fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pearl50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.indigo600.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.indigo700, fontWeight: FontWeight.w600),
      ),
    );
  }
}
