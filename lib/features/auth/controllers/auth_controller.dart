import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../app/router.dart';
import '../../../data/models/app_user.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_role.dart';
import '../../common/controllers/loading_controller.dart';

class AuthController extends GetxController {
  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;
  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxBool isAuthenticated = false.obs;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AppUser?>? _userSubscription;

  LoadingController get _loading => Get.find<LoadingController>();

  @override
  void onInit() {
    super.onInit();
    _authSubscription = _repository.authStateChanges().listen(_handleAuthChange);
  }

  Future<AppUser?> fetchProfile() => _repository.fetchCurrentUser();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _runWithLoader(() async {
      final user = await _repository.signInWithEmail(email: email, password: password);
      currentUser.value = user;
      _navigateForRole(user.role);
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required AuthRole role,
    String? departmentId,
    List<String>? subjectIds,
  }) async {
    await _runWithLoader(() async {
      final user = await _repository.registerUser(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
        departmentId: departmentId,
        subjectIds: subjectIds,
      );
      currentUser.value = user;
      _navigateForRole(user.role);
    });
  }

  Future<void> updateProfile(AppUser user) async {
    await _runWithLoader(() => _repository.updateUserProfile(user));
    currentUser.value = user;
  }

  Future<void> signOut() async {
    await _runWithLoader(_repository.signOut);
    currentUser.value = null;
    isAuthenticated.value = false;
    if (Get.currentRoute != AppRoutes.onboarding) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void _handleAuthChange(User? user) {
    _userSubscription?.cancel();
    if (user == null) {
      currentUser.value = null;
      isAuthenticated.value = false;
      return;
    }

    _userSubscription = _repository.watchCurrentUser().listen((appUser) {
      currentUser.value = appUser;
      if (appUser == null) return;
      isAuthenticated.value = true;
      _navigateForRole(appUser.role);
    });
  }

  Future<void> _runWithLoader(Future<void> Function() task) async {
    try {
      _loading.show();
      await task();
    } finally {
      _loading.hide();
    }
  }

  void _navigateForRole(AuthRole role) {
    final route = switch (role) {
      AuthRole.admin => AppRoutes.admin,
      AuthRole.reviewer => AppRoutes.reviewer,
      AuthRole.student => AppRoutes.student,
    };
    if (Get.currentRoute != route) {
      Get.offAllNamed(route);
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }
}
