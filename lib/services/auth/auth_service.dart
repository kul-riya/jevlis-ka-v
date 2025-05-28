import 'package:jevlis_ka/services/auth/auth_provider.dart';
import 'package:jevlis_ka/services/auth/auth_user.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() {
    return AuthService(FirebaseAuthProvider());
  }

  // @override
  // Future<AuthUser> createUser(
  //     {required String email, required String password}) {
  //   return provider.createUser(email: email, password: password);
  // }

  @override
  AuthUser? get currentUser {
    return provider.currentUser;
  }

  @override
  Future<void> initialize() async {
    provider.initialize();
  }

  @override
  Future<AuthUser> userLogIn(
      {required String email, required String password}) {
    return provider.userLogIn(email: email, password: password);
  }

  @override
  Future<void> userLogOut() async {
    provider.userLogOut();
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    return provider.signInWithGoogle();
  }

  @override
  Future<AuthUser> signInWithPhoneNumber({required String phoneNumber}) {
    return provider.signInWithPhoneNumber(phoneNumber: phoneNumber);
  }
}
