import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_user.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_role.dart';

final firebaseAuthStateProvider = StreamProvider.autoDispose((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges();
});

final appUserStreamProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.watchCurrentUser();
});

final currentAppUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(appUserStreamProvider).maybeWhen(
        data: (user) => user,
        orElse: () => null,
      );
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(
    repository: repo,
    ref: ref,
  );
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  AuthController({
    required AuthRepository repository,
    required this.ref,
  })  : _repository = repository,
        super(const AsyncValue.loading()) {
    _init();
  }

  final AuthRepository _repository;
  final Ref ref;

  Future<void> _init() async {
    ref.listen<AsyncValue<AppUser?>>(appUserStreamProvider, (_, next) {
      state = next;
    }, fireImmediately: true);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await _repository.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithEmail(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required AuthRole role,
    String? departmentId,
    List<String>? subjectIds,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.registerUser(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
        departmentId: departmentId,
        subjectIds: subjectIds,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile(AppUser user) async {
    try {
      await _repository.updateUserProfile(user);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
