import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_practice/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:firebase_practice/features/auth/domain/entities/app_user.dart';
import 'package:firebase_practice/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_practice/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:firebase_practice/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:firebase_practice/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:firebase_practice/features/auth/domain/usecases/sign_out.dart';
import 'package:firebase_practice/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (Ref ref) => FirebaseAuth.instance,
);

final googleSignInProvider = Provider<GoogleSignIn>(
  (Ref ref) => GoogleSignIn.instance,
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (Ref ref) => AuthRemoteDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => FirebaseAuthRepository(ref.watch(authRemoteDataSourceProvider)),
);

final signInWithEmailUseCaseProvider = Provider<SignInWithEmail>(
  (Ref ref) => SignInWithEmail(ref.watch(authRepositoryProvider)),
);

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmail>(
  (Ref ref) => SignUpWithEmail(ref.watch(authRepositoryProvider)),
);

final sendPasswordResetEmailUseCaseProvider = Provider<SendPasswordResetEmail>(
  (Ref ref) => SendPasswordResetEmail(ref.watch(authRepositoryProvider)),
);

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogle>(
  (Ref ref) => SignInWithGoogle(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOut>(
  (Ref ref) => SignOut(ref.watch(authRepositoryProvider)),
);

final authStateChangesProvider = StreamProvider<AppUser?>(
  (Ref ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final currentUserProvider = Provider<AppUser?>((Ref ref) {
  final AsyncValue<AppUser?> authState = ref.watch(authStateChangesProvider);

  return authState.maybeWhen(
    data: (AppUser? user) => user,
    orElse: () => ref.watch(authRepositoryProvider).currentUser,
  );
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _run(
      () => ref.read(signInWithEmailUseCaseProvider)(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _run(
      () => ref.read(signUpWithEmailUseCaseProvider)(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _run(() => ref.read(sendPasswordResetEmailUseCaseProvider)(email));
  }

  Future<void> signInWithGoogle() {
    return _run(() => ref.read(signInWithGoogleUseCaseProvider)());
  }

  Future<void> signOut() {
    return _run(() => ref.read(signOutUseCaseProvider)());
  }

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
