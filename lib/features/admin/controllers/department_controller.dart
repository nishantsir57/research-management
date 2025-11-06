import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/department.dart';

class DepartmentController extends GetxController {
  final RxList<Department> departments = <Department>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = FirebaseService.firestore.collection('departments').snapshots().listen((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        final subjects = (data['subjects'] as List<dynamic>? ?? [])
            .map((raw) => Subject.fromJson(Map<String, dynamic>.from(raw as Map)))
            .toList();
        return Department.fromJson({
          ...data,
          'id': doc.id,
          'subjects': subjects.map((s) => s.toJson()).toList(),
        });
      }).toList();
      departments.assignAll(items);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
