import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_role.dart';
import '../../../core/providers/firebase_providers.dart';
import '../data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore);
});

final studentsStreamProvider = StreamProvider((ref) {
  return ref.watch(userRepositoryProvider).watchUsersByRole(UserRole.student);
});

final reviewersStreamProvider = StreamProvider((ref) {
  return ref.watch(userRepositoryProvider).watchUsersByRole(UserRole.reviewer);
});
