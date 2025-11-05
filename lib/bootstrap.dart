import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';

/// Bootstraps the ResearchHub application by ensuring widgets are bound,
/// Firebase is initialised, and Riverpod's ProviderScope is set up.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(
    const ProviderScope(
      child: ResearchHubApp(),
    ),
  );
}
