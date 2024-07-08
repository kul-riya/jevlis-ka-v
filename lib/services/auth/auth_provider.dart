import 'package:jevlis_ka/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<AuthUser> userLogIn({
    required String email,
    required String password,
  });

  AuthUser? get currentUser;

  Future<void> userLogOut();

  Future<AuthUser> signInWithGoogle();
}
