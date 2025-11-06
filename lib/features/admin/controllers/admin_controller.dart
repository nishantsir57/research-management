import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/app_user.dart';
import '../../../data/models/department.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/domain/auth_role.dart';
import '../../submissions/domain/submission_repository.dart';

class AdminController extends GetxController {
  AdminController({
    SubmissionRepository? submissionRepository,
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseService.firestore,
        _submissionRepository = submissionRepository ?? SubmissionRepository();

  final FirebaseFirestore _firestore;
  final SubmissionRepository _submissionRepository;

  final RxList<AppUser> allUsers = <AppUser>[].obs;
  final RxList<AppUser> pendingReviewers = <AppUser>[].obs;
  final RxList<ResearchPaper> allPapers = <ResearchPaper>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _userSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _paperSubscription;

  CollectionReference<Map<String, dynamic>> get _departments =>
      _firestore.collection('departments');

  @override
  void onInit() {
    super.onInit();
    _userSubscription = _firestore.collection('users').snapshots().listen((snapshot) {
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return AppUser.fromJson({
          ...data,
          'id': doc.id,
          'role': data['role'],
        });
      }).toList();
      allUsers.assignAll(users);
      pendingReviewers.assignAll(
        users.where((user) => user.role == AuthRole.reviewer && !user.isReviewerApproved),
      );
    });

    _paperSubscription = FirebaseService.firestore
        .collection('papers')
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final papers = snapshot.docs.map((doc) {
        final data = doc.data();
        return ResearchPaper.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
      allPapers.assignAll(papers);
    });
  }

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

  @override
  void onClose() {
    _userSubscription?.cancel();
    _paperSubscription?.cancel();
    super.onClose();
  }
}
