import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/bindings/app_bindings.dart';
import '../core/widgets/app_loading_overlay.dart';
import 'router.dart';
import 'theme.dart';

class KohinchhaApp extends StatelessWidget {
  const KohinchhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kohinchha',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      builder: (context, child) {
        final responsiveChild = ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox.shrink(),
          breakpoints: const [
            Breakpoint(start: 0, end: 480, name: MOBILE),
            Breakpoint(start: 481, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1200, name: DESKTOP),
            Breakpoint(start: 1201, end: double.infinity, name: '4K'),
          ],
        );
        return Stack(
          children: [
            responsiveChild,
            const AppLoadingOverlay(),
          ],
        );
      },
    );
  }
}
