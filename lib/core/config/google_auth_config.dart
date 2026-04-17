class GoogleAuthConfig {
  const GoogleAuthConfig._();

  static String get serverClientId {
    final String value = const String.fromEnvironment(
      'FIREBASE_GOOGLE_SERVER_CLIENT_ID',
    );

    if (value.isEmpty) {
      throw StateError(
        'Falta FIREBASE_GOOGLE_SERVER_CLIENT_ID. Revisa README.md.',
      );
    }

    return value;
  }
}
