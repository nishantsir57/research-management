import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_role.dart';
import '../../features/admin/presentation/views/admin_dashboard_view.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/auth/presentation/views/account_blocked_view.dart';
import '../../features/auth/presentation/views/sign_in_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/auth/presentation/views/splash_view.dart';
import '../../features/dashboard/presentation/views/reviewer_dashboard_view.dart';
import '../../features/dashboard/presentation/views/student_dashboard_view.dart';
import '../../features/reviewer/presentation/views/reviewer_pending_view.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authUserChangesProvider);
  final notifier = GoRouterRefreshStream(authRepository.authStateChanges());
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: '/auth/blocked',
        builder: (context, state) => const AccountBlockedView(),
      ),
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentDashboardView(),
      ),
      GoRoute(
        path: '/reviewer',
        builder: (context, state) => const ReviewerDashboardView(),
      ),
      GoRoute(
        path: '/reviewer/pending',
        builder: (context, state) => const ReviewerPendingView(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardView(),
      ),
    ],
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final userAsync = authState;

      if (userAsync.isLoading) {
        return state.matchedLocation == '/' ? null : '/';
      }

      final user = userAsync.valueOrNull;

      if (userAsync.hasError) {
        return '/auth/sign-in';
      }

      if (user == null) {
        if (isAuthRoute) return null;
        return '/auth/sign-in';
      }

      if (user.blocked) {
        return state.matchedLocation == '/auth/blocked' ? null : '/auth/blocked';
      }

      if (user.role.isReviewer && !user.approvedReviewer) {
        if (!state.matchedLocation.startsWith('/reviewer/pending')) {
          return '/reviewer/pending';
        }
        return null;
      }

      if (user.role.isAdmin) {
        return state.matchedLocation.startsWith('/admin') ? null : '/admin';
      }

      if (user.role.isReviewer) {
        return state.matchedLocation.startsWith('/reviewer') ? null : '/reviewer';
      }

      if (user.role.isStudent) {
        return state.matchedLocation.startsWith('/student') ? null : '/student';
      }

      return null;
    },
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
