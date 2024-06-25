import 'package:jevlis_ka/auth/auth_provider.dart';
import 'package:jevlis_ka/auth/auth_user.dart';

class GoogleAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> userLogOut() {
    // TODO: implement userLogOut
    throw UnimplementedError();
  }

  Future<AuthUser> userLoginIn(
      {required String email, required String password}) {
    // TODO: implement userLoginIn
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<AuthUser> userLogIn(
      {required String email, required String password}) {
    // TODO: implement userLogIn
    throw UnimplementedError();
  }
}
