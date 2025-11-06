import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/services/firebase_service.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseService.initialize();
    runApp(const KohinchhaApp());
  }, (error, stackTrace) {
    FlutterError.presentError(FlutterErrorDetails(exception: error, stack: stackTrace));
  });
}
