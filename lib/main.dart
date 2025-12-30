import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tandurast/core/config/routes/app_router.dart';
import 'package:tandurast/core/config/theme/app_theme.dart';
import 'package:tandurast/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // Note: connecting to firebase requires the GoogleService-Info.plist (iOS)
  // and google-services.json (Android) files to be present in the project.
  // For now, we will wrap this in a try-catch so the app runs even without them
  // during this initial setup phase.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint(
      "Firebase init failed (expected if config files are missing): $e",
    );
  }

  // Initialize Dependency Injection
  await di.init();

  runApp(const TandurastApp());
}

class TandurastApp extends StatelessWidget {
  const TandurastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tandurast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
