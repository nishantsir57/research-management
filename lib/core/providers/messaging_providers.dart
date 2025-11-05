import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/messaging_service.dart';
import 'firebase_providers.dart';

final messagingServiceProvider = Provider<MessagingService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return MessagingService(messaging);
});
