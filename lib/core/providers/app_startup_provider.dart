import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'messaging_providers.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  final messaging = ref.read(messagingServiceProvider);
  await messaging.initialise();
});
