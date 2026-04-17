import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/core/utils/app_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

AppException mapFirebaseAuthException(FirebaseAuthException exception) {
  switch (exception.code) {
    case 'invalid-email':
      return const AppException('El correo no tiene un formato válido.');
    case 'user-disabled':
      return const AppException('Esta cuenta fue deshabilitada.');
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return const AppException('Correo o contraseña incorrectos.');
    case 'email-already-in-use':
      return const AppException('Ese correo ya está registrado.');
    case 'weak-password':
      return const AppException(
        'La contraseña debe tener al menos 6 caracteres.',
      );
    case 'too-many-requests':
      return const AppException(
        'Hay demasiados intentos. Espera un momento e inténtalo otra vez.',
      );
    case 'network-request-failed':
      return const AppException('No se pudo conectar con Firebase.');
    default:
      return AppException(
        exception.message ?? 'Ocurrió un error autenticando la cuenta.',
      );
  }
}

AppException mapFirebaseException(FirebaseException exception) {
  switch (exception.code) {
    case 'permission-denied':
      return const AppException(
        'No tienes permisos para acceder a estos datos en Firestore.',
      );
    case 'unavailable':
      return const AppException(
        'Firestore no está disponible en este momento.',
      );
    case 'not-found':
      return const AppException('No encontramos el recurso solicitado.');
    default:
      return AppException(
        exception.message ?? 'Ocurrió un error consultando Firestore.',
      );
  }
}

AppException mapGoogleSignInException(GoogleSignInException exception) {
  switch (exception.code) {
    case GoogleSignInExceptionCode.canceled:
      return const AppException('Cancelaste el inicio de sesión con Google.');
    case GoogleSignInExceptionCode.clientConfigurationError:
      return const AppException(
        'Google Sign-In no está bien configurado en Firebase para esta app.',
      );
    case GoogleSignInExceptionCode.providerConfigurationError:
      return const AppException(
        'Los servicios de Google no están disponibles o están mal configurados.',
      );
    case GoogleSignInExceptionCode.uiUnavailable:
      return const AppException(
        'No se pudo abrir la interfaz de Google Sign-In.',
      );
    case GoogleSignInExceptionCode.interrupted:
      return const AppException(
        'El flujo de Google Sign-In se interrumpió. Inténtalo otra vez.',
      );
    case GoogleSignInExceptionCode.userMismatch:
      return const AppException(
        'La cuenta seleccionada no coincide con la sesión actual.',
      );
    case GoogleSignInExceptionCode.unknownError:
      return AppException(
        exception.description ?? 'Ocurrió un error con Google Sign-In.',
      );
  }
}
