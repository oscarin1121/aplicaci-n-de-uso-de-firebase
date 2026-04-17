# aplicaci-n-de-uso-de-firebase

Aplicacion Flutter para practicar Firebase Auth, Firestore, Riverpod y GoRouter.

## Configuracion local

Este repo ya no incluye archivos reales de Firebase para que pueda mantenerse publico.

Necesitas agregar localmente:

1. `android/app/google-services.json`
2. `ios/Runner/GoogleService-Info.plist`
3. `ios/Flutter/FirebaseConfig.xcconfig`
4. Un archivo de `dart-define` basado en `env/firebase.example.json`

## Paso a paso

1. Copia tus archivos Firebase descargados desde la consola:
   - `google-services.json` a `android/app/google-services.json`
   - `GoogleService-Info.plist` a `ios/Runner/GoogleService-Info.plist`

2. Crea `ios/Flutter/FirebaseConfig.xcconfig` a partir de `ios/Flutter/FirebaseConfig.example.xcconfig`

3. Crea `env/firebase.local.json` a partir de `env/firebase.example.json`

4. Completa los valores reales de tu proyecto Firebase

5. Corre la app con:

```bash
flutter run --dart-define-from-file=env/firebase.local.json
```

## Valores necesarios

### `env/firebase.local.json`

- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_ANDROID_APP_ID`
- `FIREBASE_IOS_API_KEY`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_IOS_BUNDLE_ID`
- `FIREBASE_GOOGLE_SERVER_CLIENT_ID`

### `ios/Flutter/FirebaseConfig.xcconfig`

- `GOOGLE_IOS_CLIENT_ID`
- `GOOGLE_IOS_REVERSED_CLIENT_ID`
- `GOOGLE_IOS_SERVER_CLIENT_ID`

Puedes obtener estos valores desde:
- `GoogleService-Info.plist`
- `google-services.json`
- Firebase Console > Project settings
