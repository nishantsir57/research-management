import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/messaging_providers.dart';
import '../../auth/domain/auth_providers.dart';

final userSessionProvider = Provider<void>((ref) {
  ref.listen(authUserChangesProvider, (previous, next) async {
    if (!next.hasValue) return;
    final user = next.value;
    final authRepo = ref.read(authRepositoryProvider);
    final messaging = ref.read(messagingServiceProvider);

    if (user != null) {
      final token = await messaging.getToken();
      if (token != null && !user.fcmTokens.contains(token)) {
        await authRepo.saveFcmToken(token);
      }
    } else {
      final previousUser = previous?.value;
      if (previousUser != null) {
        final token = await messaging.getToken();
        if (token != null) {
          await authRepo.removeFcmToken(token);
        }
      }
    }
  });
});
