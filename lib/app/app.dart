import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/app_loading_overlay.dart';
import 'router.dart';
import 'theme.dart';

class KohinchhaApp extends ConsumerWidget {
  const KohinchhaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kohinchha',
      theme: AppTheme.light(),
      routerConfig: router,
      builder: (context, child) {
        // Ensure overlay (loading indicator, etc.) has Directionality and Theme from
        // MaterialApp by placing it inside the builder.
        return Stack(
          children: [child ?? const SizedBox.shrink(), const AppLoadingOverlay()],
        );
      },
    );
  }
}
