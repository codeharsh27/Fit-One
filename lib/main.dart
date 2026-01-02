import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tandurast/core/config/routes/app_router.dart';
import 'package:tandurast/core/config/theme/app_theme.dart';
import 'package:tandurast/core/di/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tandurast/core/data/models/workout_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutSessionAdapter());
  Hive.registerAdapter(ExerciseLogAdapter());
  Hive.registerAdapter(SetLogAdapter());
  await Hive.openBox('settings');

  // Initialize Firebase (try-catch)
  try {
    // We let Firebase native SDKs auto-detect config from google-services.json
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init failed: $e");
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
      key:
          UniqueKey(), // Force rebuild on hot reload if key changes (it won't change on hot reload necessarily, but it's good practice for debugging state issues)
      // Actually, UniqueKey will rebuild on EVERY build. That's bad for perf but good for debugging "stuck" state.
      // Let's NOT use UniqueKey() on every build.
      // Instead, just changing the file content slightly will trigger reload.
      title: 'FitOne',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
