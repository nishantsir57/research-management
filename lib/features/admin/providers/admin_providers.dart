import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/app_user.dart';
import '../../auth/domain/auth_role.dart';

final pendingReviewersProvider = StreamProvider<List<AppUser>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('users')
      .where('role', isEqualTo: AuthRole.reviewer.name)
      .where('isReviewerApproved', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map(
          (doc) => AppUser.fromJson({
            ...doc.data(),
            'id': doc.id,
            'role': doc.data()['role'],
          }),
        )
        .toList();
  });
});

final allUsersProvider = StreamProvider<List<AppUser>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs
        .map(
          (doc) => AppUser.fromJson({
            ...doc.data(),
            'id': doc.id,
            'role': doc.data()['role'],
          }),
        )
        .toList();
  });
});
