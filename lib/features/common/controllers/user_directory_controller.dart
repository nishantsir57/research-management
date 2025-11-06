import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/models/app_user.dart';

class UserDirectoryController extends GetxController {
  final RxList<AppUser> users = <AppUser>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = FirebaseService.firestore.collection('users').snapshots().listen((snapshot) {
      final data = snapshot.docs
          .map(
            (doc) => AppUser.fromJson({
              ...doc.data(),
              'id': doc.id,
              'role': doc.data()['role'],
            }),
          )
          .toList();
      users.assignAll(data);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
