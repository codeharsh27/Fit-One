// File: lib/firebase_options.dart
// This file is manually maintained since CLI configuration failed.
// It uses standard placeholders that delegate to google-services.json on Android/iOS.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not configured. Use flutterfire configure for Web support.',
      );
    }
    // On Android and iOS, firebase_core uses the native config files
    // (google-services.json and GoogleService-Info.plist) automatically
    // when no options are provided.
    // However, initializeApp requires an options parameter if we want to be explicit,
    // OR we can pass null/nothing to let it find the native file.
    // BUT the generated code usually returns absolute values.

    // TRICK: FlutterFire can auto-detect on Android/iOS if we simply don't pass options!
    // But our main.dart calls `initializeApp(options: ...)`

    // So we will throw an error here to force the main.dart to use the "Auto-detect" path?
    // No, better to update main.dart to support auto-detection.

    throw UnsupportedError(
      'DefaultFirebaseOptions are not set. We will use native auto-detection.',
    );
  }
}
