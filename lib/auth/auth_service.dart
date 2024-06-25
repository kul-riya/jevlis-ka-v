import 'package:jevlis_ka/auth/auth_provider.dart';
import 'package:jevlis_ka/auth/auth_user.dart';
import 'package:jevlis_ka/auth/firebase_auth_provider.dart';

class FirebaseAuthService implements AuthProvider {
  final AuthProvider provider;

  FirebaseAuthService(this.provider);

  factory FirebaseAuthService.firebase() {
    return FirebaseAuthService(FirebaseAuthProvider());
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    return provider.createUser(email: email, password: password);
  }

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
}
