import 'package:flutter/foundation.dart';
import 'package:jevlis_ka/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateUnintialized extends AuthState {
  const AuthStateUnintialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception});
}

class AuthStateLoggedInUser extends AuthState {
  final AuthUser user;
  const AuthStateLoggedInUser({required this.user});
}

class AuthStateChosenCanteen extends AuthState {
  final String canteenId;
  final String name;

  const AuthStateChosenCanteen({required this.name, required this.canteenId});
}

class AuthStateLoggedInCanteen extends AuthState {
  final AuthUser user;

  const AuthStateLoggedInCanteen({required this.user});
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;

  const AuthStateLoggedOut({required this.exception});
}

// App states for
// 1. If items in cart: Item screen
// 2. If order placed and paid for: Cart screen or Item Screen with timeline at bottom
