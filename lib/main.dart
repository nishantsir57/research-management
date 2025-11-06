import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/firebase_providers.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebase();
    runApp(const ProviderScope(child: KohinchhaApp()));
  }, (error, stackTrace) {
    FlutterError.presentError(FlutterErrorDetails(exception: error, stack: stackTrace));
  });
}
