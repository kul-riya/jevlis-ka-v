import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String uid;

  const AuthUser({required this.uid});

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      uid: user.uid,
    );
  }
}
