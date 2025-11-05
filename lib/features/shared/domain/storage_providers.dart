import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return StorageRepository(storage);
});
