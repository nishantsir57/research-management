import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/app_user.dart';

final userDirectoryProvider = StreamProvider<List<AppUser>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return AppUser.fromJson({
        ...data,
        'id': doc.id,
        'role': data['role'],
      });
    }).toList();
  });
});
