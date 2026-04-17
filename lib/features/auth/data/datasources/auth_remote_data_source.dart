import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/core/config/google_auth_config.dart';
import 'package:firebase_practice/core/utils/app_exception.dart';
import 'package:firebase_practice/core/utils/firebase_error_mapper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  Future<void>? _googleInitialization;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseAuthException(exception);
    } catch (_) {
      throw const AppException('No se pudo iniciar la sesión.');
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential credentials = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final User? user = credentials.user;
      if (user == null) {
        return;
      }

      final String resolvedName = (displayName?.trim().isNotEmpty ?? false)
          ? displayName!.trim()
          : _friendlyNameFromEmail(email);

      await user.updateDisplayName(resolvedName);
      await user.reload();
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseAuthException(exception);
    } catch (_) {
      throw const AppException('No se pudo crear la cuenta.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseAuthException(exception);
    } catch (_) {
      throw const AppException('No se pudo enviar el correo de recuperación.');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _ensureGoogleInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AppException(
          'Google Sign-In no está disponible en esta plataforma.',
        );
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AppException(
          'Google no devolvió un token válido para autenticarse.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseAuthException(exception);
    } on GoogleSignInException catch (exception) {
      throw mapGoogleSignInException(exception);
    } on StateError catch (exception) {
      throw AppException(exception.message);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('No se pudo iniciar sesión con Google.');
    }
  }

  Future<void> signOut() async {
    final bool shouldSignOutGoogle =
        _firebaseAuth.currentUser?.providerData.any(
          (UserInfo userInfo) =>
              userInfo.providerId == GoogleAuthProvider.PROVIDER_ID,
        ) ??
        false;

    try {
      await _firebaseAuth.signOut();

      if (shouldSignOutGoogle) {
        try {
          await _ensureGoogleInitialized();
          await _googleSignIn.signOut();
        } on GoogleSignInException {
          // Firebase sign out already completed; ignore Google cache cleanup failures.
        }
      }
    } on FirebaseAuthException catch (exception) {
      throw mapFirebaseAuthException(exception);
    } catch (_) {
      throw const AppException('No se pudo cerrar la sesión.');
    }
  }

  Future<void> _ensureGoogleInitialized() {
    return _googleInitialization ??= _googleSignIn.initialize(
      serverClientId: GoogleAuthConfig.serverClientId,
    );
  }

  String _friendlyNameFromEmail(String email) {
    final String localPart = email.split('@').first.trim();
    final List<String> words = localPart
        .split(RegExp(r'[._-]+'))
        .where((String item) => item.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'Developer';
    }

    return words
        .map(
          (String word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
