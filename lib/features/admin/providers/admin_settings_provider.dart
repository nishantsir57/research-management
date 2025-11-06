import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_providers.dart';
import '../../../data/models/app_settings.dart';

final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('settings').doc('app').snapshots().map((snapshot) {
    if (!snapshot.exists) {
      return const AppSettings(id: 'app');
    }
    return AppSettings.fromJson({
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  });
});
