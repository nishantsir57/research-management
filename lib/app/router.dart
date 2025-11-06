import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../data/models/app_user.dart';
import '../features/admin/presentation/admin_pages.dart';
import '../features/admin/presentation/admin_shell.dart';
import '../features/auth/domain/auth_role.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/onboarding_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/auth/providers/auth_controller.dart';
import '../features/dashboard/presentation/student/student_achievements_page.dart';
import '../features/dashboard/presentation/student/student_discussions_page.dart';
import '../features/dashboard/presentation/student/student_home_page.dart';
import '../features/dashboard/presentation/student/student_network_page.dart';
import '../features/dashboard/presentation/student/student_papers_page.dart';
import '../features/dashboard/presentation/student/student_settings_page.dart';
import '../features/dashboard/presentation/student/student_submit_page.dart';
import '../features/dashboard/presentation/student/student_trending_page.dart';
import '../features/submissions/presentation/paper_detail_page.dart';
import '../features/dashboard/presentation/student_shell.dart';
import '../features/review/presentation/reviewer/reviewer_assigned_page.dart';
import '../features/review/presentation/reviewer/reviewer_dashboard_page.dart';
import '../features/review/presentation/reviewer/reviewer_discussions_page.dart';
import '../features/review/presentation/reviewer/reviewer_history_page.dart';
import '../features/review/presentation/reviewer/reviewer_settings_page.dart';
import '../features/review/presentation/reviewer_shell.dart';

/// A small ChangeNotifier that listens to a [Stream] and notifies listeners on events.
/// Used to hook streams (like auth/user stream) into GoRouter's refreshListenable.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final appUserStream = ref.watch(appUserStreamProvider.stream);
  final authState = ref.watch(authControllerProvider);

  String? determineRedirect(BuildContext context, GoRouterState state, AppUser? user) {
    final location = state.matchedLocation;
    final isAuthRoute =
        location == '/login' || location.startsWith('/signup') || location == '/' || location == '/onboarding';
    final roleHome = _homeForRole(user?.role);

    if (user == null) {
      if (location == '/' || location == '/onboarding') {
        return null;
      }
      if (!isAuthRoute) {
        return '/';
      }
      return null;
    }

    if (isAuthRoute) {
      return roleHome;
    }

    if (location.startsWith('/student') && user.role != AuthRole.student) {
      return roleHome;
    }
    if (location.startsWith('/reviewer') && user.role != AuthRole.reviewer) {
      return roleHome;
    }
    if (location.startsWith('/admin') && user.role != AuthRole.admin) {
      return roleHome;
    }
    return null;
  }

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
  refreshListenable: GoRouterRefreshStream(appUserStream),
    redirect: (context, state) {
      if (authState.isLoading) return null;
      final user = ref.read(currentAppUserProvider);
      return determineRedirect(context, state, user);
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'onboarding',
        builder: (context, state) {
          return OnboardingPage(onGetStarted: () => context.go('/login'));
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final role = state.extra is AuthRole ? state.extra as AuthRole : AuthRole.student;
          return SignUpPage(initialRole: role);
        },
      ),
      ShellRoute(
        navigatorKey: _studentNavigatorKey,
        builder: (context, state, child) => StudentShellPage(child: child),
        routes: [
          GoRoute(
            path: '/student/home',
            builder: (context, state) => const StudentHomePage(),
          ),
          GoRoute(
            path: '/student/papers',
            builder: (context, state) => const StudentMyPapersPage(),
          ),
          GoRoute(
            path: '/student/submit',
            builder: (context, state) => const StudentSubmitPaperPage(),
          ),
          GoRoute(
            path: '/student/discussions',
            builder: (context, state) => const StudentDiscussionsPage(),
          ),
          GoRoute(
            path: '/student/trending',
            builder: (context, state) => const StudentTrendingPage(),
          ),
          GoRoute(
            path: '/student/achievements',
            builder: (context, state) => const StudentAchievementsPage(),
          ),
          GoRoute(
            path: '/student/network',
            builder: (context, state) => const StudentNetworkPage(),
          ),
          GoRoute(
            path: '/student/settings',
            builder: (context, state) => const StudentSettingsPage(),
          ),
          GoRoute(
            path: '/student/paper/:paperId',
            builder: (context, state) {
              final id = state.pathParameters['paperId']!;
              return PaperDetailPage(paperId: id);
            },
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _reviewerNavigatorKey,
        builder: (context, state, child) => ReviewerShellPage(child: child),
        routes: [
          GoRoute(
            path: '/reviewer/home',
            builder: (context, state) => const ReviewerDashboardPage(),
          ),
          GoRoute(
            path: '/reviewer/assigned',
            builder: (context, state) => const ReviewerAssignedPapersPage(),
          ),
          GoRoute(
            path: '/reviewer/history',
            builder: (context, state) => const ReviewerHistoryPage(),
          ),
          GoRoute(
            path: '/reviewer/discussions',
            builder: (context, state) => const ReviewerDiscussionsPage(),
          ),
          GoRoute(
            path: '/reviewer/settings',
            builder: (context, state) => const ReviewerSettingsPage(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _adminNavigatorKey,
        builder: (context, state, child) => AdminShellPage(child: child),
        routes: [
          GoRoute(
            path: '/admin/home',
            builder: (context, state) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: '/admin/departments',
            builder: (context, state) => const AdminDepartmentsPage(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: '/admin/papers',
            builder: (context, state) => const AdminPapersPage(),
          ),
          GoRoute(
            path: '/admin/settings',
            builder: (context, state) => const AdminSettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Route not found: ${state.matchedLocation}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to start'),
            ),
          ],
        ),
      ),
    ),
  );
});

String _homeForRole(AuthRole? role) {
  switch (role) {
    case AuthRole.reviewer:
      return '/reviewer/home';
    case AuthRole.admin:
      return '/admin/home';
    case AuthRole.student:
    default:
      return '/student/home';
  }
}

final _studentNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'student');
final _reviewerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'reviewer');
final _adminNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'admin');
