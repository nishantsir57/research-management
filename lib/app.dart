import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/shared/providers/user_session_provider.dart';

class ResearchHubApp extends ConsumerWidget {
  const ResearchHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    ref.watch(userSessionProvider);
    return MaterialApp.router(
      title: 'ResearchHub',
      theme: appTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
