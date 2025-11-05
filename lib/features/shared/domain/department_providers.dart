import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/department_repository.dart';

final departmentRepositoryProvider = Provider<DepartmentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return DepartmentRepository(firestore);
});

final departmentsStreamProvider = StreamProvider((ref) {
  return ref.watch(departmentRepositoryProvider).watchDepartments();
});
