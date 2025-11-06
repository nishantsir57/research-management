import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/department.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/domain/auth_role.dart';
import '../../submissions/domain/submission_repository.dart';
import 'admin_settings_provider.dart';
import 'department_providers.dart';

final adminControllerProvider = Provider<AdminController>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final submissionRepository = ref.watch(submissionRepositoryProvider);
  return AdminController(
    firestore: firestore,
    submissionRepository: submissionRepository,
  );
});

class AdminController {
  AdminController({
    required FirebaseFirestore firestore,
    required SubmissionRepository submissionRepository,
  })  : _firestore = firestore,
        _submissionRepository = submissionRepository;

  final FirebaseFirestore _firestore;
  final SubmissionRepository _submissionRepository;

  CollectionReference<Map<String, dynamic>> get _departments =>
      _firestore.collection('departments');

  Future<void> addDepartment({
    required String name,
    List<String>? subjects,
  }) async {
    final doc = _departments.doc();
    await doc.set({
      'name': name,
      'isActive': true,
      'subjects': (subjects ?? const [])
          .map(
            (subject) => Subject(
              id: _firestore.collection('subjects').doc().id,
              name: subject,
              departmentId: doc.id,
            ).toJson(),
          )
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addSubject({
    required String departmentId,
    required String subjectName,
  }) async {
    final subject = Subject(
      id: _firestore.collection('subjects').doc().id,
      name: subjectName,
      departmentId: departmentId,
    );
    await _departments.doc(departmentId).update({
      'subjects': FieldValue.arrayUnion([subject.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeSubject({
    required Department department,
    required Subject subject,
  }) async {
    await _departments.doc(department.id).update({
      'subjects': FieldValue.arrayRemove([subject.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleDepartment({
    required String departmentId,
    required bool isActive,
  }) async {
    await _departments.doc(departmentId).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> approveReviewer({
    required String reviewerId,
    required bool approved,
  }) async {
    await _firestore.collection('users').doc(reviewerId).update({
      'isReviewerApproved': approved,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> blockUser({
    required String userId,
    required bool block,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'isBlocked': block,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> reassignReviewer({
    required String paperId,
    required String reviewerId,
  }) async {
    await _submissionRepository.reassignReviewer(
      paperId: paperId,
      reviewerId: reviewerId,
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _firestore.collection('settings').doc(settings.id).set({
      'aiPreReviewEnabled': settings.aiPreReviewEnabled,
      'allowStudentRegistration': settings.allowStudentRegistration,
      'allowReviewerRegistration': settings.allowReviewerRegistration,
      'allowPublicVisibility': settings.allowPublicVisibility,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
