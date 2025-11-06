import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/common/controllers/loading_controller.dart';
import '../constants/app_colors.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadingController>();
    return Obx(() {
      final isLoading = controller.isLoading.value;
      if (!isLoading) return const SizedBox.shrink();
      return IgnorePointer(
        ignoring: false,
        child: AnimatedOpacity(
          opacity: isLoading ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            color: Colors.black.withValues(alpha: 0.2),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation(AppColors.violet500),
              ),
            ),
          ),
        ),
      );
    });
  }
}
