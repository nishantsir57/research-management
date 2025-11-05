import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/app_settings.dart';

class SettingsRepository {
  SettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const documentPath = 'settings/app';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.doc(documentPath);

  Stream<AppSettings> watchSettings() {
    return _doc.snapshots().map(AppSettings.fromDocument);
  }

  Future<AppSettings> fetchSettings() async {
    final doc = await _doc.get();
    if (!doc.exists) {
      final settings = AppSettings(aiReviewEnabled: true, updatedAt: DateTime.now());
      await _doc.set(settings.toMap());
      return settings;
    }
    return AppSettings.fromDocument(doc);
  }

  Future<void> updateAIReview(bool enabled) async {
    await _doc.set(
      {
        'aiReviewEnabled': enabled,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
