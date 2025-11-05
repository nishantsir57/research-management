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
import '../../features/admin/presentation/views/admin_pending_view.dart';
import '../../features/dashboard/presentation/views/reviewer_dashboard_view.dart';
import '../../features/dashboard/presentation/views/student_dashboard_view.dart';
import '../../features/papers/presentation/views/paper_list_page.dart';
import '../../features/papers/presentation/views/paper_view_page.dart';
import '../../features/reviewer/presentation/views/reviewer_pending_view.dart';

final pendingRedirectProvider = StateProvider<String?>((ref) => null);

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
      GoRoute(
        path: '/admin/pending',
        builder: (context, state) => const AdminPendingView(),
      ),
      GoRoute(
        path: '/papers',
        builder: (context, state) => const PaperListPage(),
      ),
      GoRoute(
        path: '/paper/:paperId',
        pageBuilder: (context, state) {
          final paperId = state.pathParameters['paperId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: PaperViewPage(paperId: paperId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(curved),
                  child: child,
                ),
              );
            },
          );
        },
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
        if (state.matchedLocation != '/') {
          final pendingLocation = state.uri.path + (state.uri.hasQuery ? '?${state.uri.query}' : '');
          ref.read(pendingRedirectProvider.notifier).state = pendingLocation;
        }
        return '/auth/sign-in';
      }

      if (user.blocked) {
        ref.read(pendingRedirectProvider.notifier).state = null;
        return state.matchedLocation == '/auth/blocked' ? null : '/auth/blocked';
      }

      if (user.role.isReviewer && !user.approvedReviewer) {
        if (!state.matchedLocation.startsWith('/reviewer/pending')) {
          return '/reviewer/pending';
        }
        return null;
      }

      if (user.role.isAdmin && !user.approvedAdmin) {
        if (!state.matchedLocation.startsWith('/admin/pending')) {
          return '/admin/pending';
        }
        return null;
      }

      final pendingRedirect = ref.read(pendingRedirectProvider);
      if (pendingRedirect != null && pendingRedirect != state.matchedLocation) {
        ref.read(pendingRedirectProvider.notifier).state = null;
        return pendingRedirect;
      }

      final isPaperRoute = state.matchedLocation.startsWith('/paper');
      final isPapersRoute = state.matchedLocation.startsWith('/papers');

      if (user.role.isAdmin) {
        final allow = state.matchedLocation.startsWith('/admin') || isPaperRoute || isPapersRoute;
        return allow ? null : '/admin';
      }

      if (user.role.isReviewer) {
        final allow = state.matchedLocation.startsWith('/reviewer') || isPaperRoute || isPapersRoute;
        return allow ? null : '/reviewer';
      }

      if (user.role.isStudent) {
        final allow = state.matchedLocation.startsWith('/student') || isPaperRoute || isPapersRoute;
        return allow ? null : '/student';
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
