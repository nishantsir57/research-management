import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/department.dart';

final departmentsProvider = StreamProvider<List<Department>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('departments').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final subjectsCollection = data['subjects'] as List<dynamic>? ?? [];
      final subjects = subjectsCollection
          .map((raw) => Subject.fromJson({
                ...raw as Map<String, dynamic>,
              }))
          .toList();
      return Department.fromJson({
        ...data,
        'id': doc.id,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      });
    }).toList();
  });
});
