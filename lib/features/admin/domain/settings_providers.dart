import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SettingsRepository(firestore);
});

final appSettingsStreamProvider = StreamProvider((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

final aiReviewEnabledProvider = Provider<bool>((ref) {
  final asyncSettings = ref.watch(appSettingsStreamProvider);
  return asyncSettings.maybeWhen(data: (settings) => settings.aiReviewEnabled, orElse: () => true);
});
