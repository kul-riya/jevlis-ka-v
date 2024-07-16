import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventEmailLoginUser extends AuthEvent {
  final String email;
  final String password;

  const AuthEventEmailLoginUser({required this.email, required this.password});
}

class AuthEventGoogleLoginUser extends AuthEvent {
  const AuthEventGoogleLoginUser();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister({required this.email, required this.password});
}

class AuthEventLogOut extends AuthEvent {}
