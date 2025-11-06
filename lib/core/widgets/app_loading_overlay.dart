import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/common/providers/loading_provider.dart';
import '../constants/app_colors.dart';

class AppLoadingOverlay extends ConsumerWidget {
  const AppLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingProvider);
    if (!isLoading) return const SizedBox.shrink();

    return IgnorePointer(
      ignoring: false,
      child: AnimatedOpacity(
        opacity: isLoading ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation(AppColors.violet500),
                ),
              ),
              SizedBox(height: 16),
              // Text(
              //   'Processing...',
              //   style: TextStyle(
              //     fontWeight: FontWeight.w600,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
