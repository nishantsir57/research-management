import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/app_settings.dart';

class SettingsController extends GetxController {
  final Rx<AppSettings> settings = const AppSettings(id: 'app').obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = FirebaseService.firestore
        .collection('settings')
        .doc('app')
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;
      final data = snapshot.data() ?? {};
      settings.value = AppSettings.fromJson({
        ...data,
        'id': snapshot.id,
      });
    });
  }

  Future<void> saveSettings(AppSettings updated) async {
    await FirebaseService.firestore.collection('settings').doc(updated.id).set({
      'aiPreReviewEnabled': updated.aiPreReviewEnabled,
      'allowStudentRegistration': updated.allowStudentRegistration,
      'allowReviewerRegistration': updated.allowReviewerRegistration,
      'allowPublicVisibility': updated.allowPublicVisibility,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
