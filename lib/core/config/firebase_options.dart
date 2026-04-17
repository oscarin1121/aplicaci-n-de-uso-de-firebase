import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions no está configurado para web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no soporta esta plataforma.',
        );
    }
  }

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _readRequired('FIREBASE_ANDROID_API_KEY'),
    appId: _readRequired('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: _readRequired('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _readRequired('FIREBASE_PROJECT_ID'),
    storageBucket: _readRequired('FIREBASE_STORAGE_BUCKET'),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _readRequired('FIREBASE_IOS_API_KEY'),
    appId: _readRequired('FIREBASE_IOS_APP_ID'),
    messagingSenderId: _readRequired('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _readRequired('FIREBASE_PROJECT_ID'),
    storageBucket: _readRequired('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: _readRequired('FIREBASE_IOS_BUNDLE_ID'),
  );

  static String _readRequired(String key) {
    final String value = String.fromEnvironment(key);

    if (value.isEmpty) {
      throw StateError(
        'Falta la variable $key. Revisa README.md y env/firebase.example.json.',
      );
    }

    return value;
  }
}
