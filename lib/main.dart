import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/app/app.dart';
import 'package:firebase_practice/core/config/firebase_options.dart';
import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget child;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    child = const FirebasePracticeApp();
  } catch (error) {
    child = FirebaseSetupRequiredApp(message: error.toString());
  }

  runApp(ProviderScope(child: child));
}

class FirebaseSetupRequiredApp extends StatelessWidget {
  const FirebaseSetupRequiredApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                color: AppColors.surfaceBright,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Falta la configuracion local de Firebase',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Este repo es publico y no incluye archivos reales de Firebase.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Configura lo siguiente localmente:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '1. android/app/google-services.json\n'
                        '2. ios/Runner/GoogleService-Info.plist\n'
                        '3. ios/Flutter/FirebaseConfig.xcconfig\n'
                        '4. flutter run --dart-define-from-file=env/firebase.local.json',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
