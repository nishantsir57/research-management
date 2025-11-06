import 'package:get/get.dart';

import '../features/admin/presentation/admin_shell.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/onboarding_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/dashboard/presentation/student_shell.dart';
import '../features/review/presentation/reviewer_shell.dart';
import '../features/submissions/presentation/paper_detail_page.dart';

abstract class AppRoutes {
  static const onboarding = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const student = '/student';
  static const reviewer = '/reviewer';
  static const admin = '/admin';
  static const paperDetail = '/paper';
}

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingPage(onGetStarted: () => Get.offNamed(AppRoutes.login)),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpPage(),
    ),
    GetPage(
      name: AppRoutes.student,
      page: () => const StudentShellPage(),
    ),
    GetPage(
      name: AppRoutes.reviewer,
      page: () => const ReviewerShellPage(),
    ),
    GetPage(
      name: AppRoutes.admin,
      page: () => const AdminShellPage(),
    ),
    GetPage(
      name: '${AppRoutes.paperDetail}/:id',
      page: () => PaperDetailPage(paperId: Get.parameters['id']!),
    ),
  ];
}
