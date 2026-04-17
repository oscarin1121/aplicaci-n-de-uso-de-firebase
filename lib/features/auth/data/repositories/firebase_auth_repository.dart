import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_practice/features/auth/domain/entities/app_user.dart';
import 'package:firebase_practice/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map(_mapUser);
  }

  @override
  AppUser? get currentUser => _mapUser(_remoteDataSource.currentUser);

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() => _remoteDataSource.signInWithGoogle();

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _remoteDataSource.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  AppUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
