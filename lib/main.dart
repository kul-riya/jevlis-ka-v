import 'dart:developer' show log;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_state.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/theme/theme.dart';
import 'package:jevlis_ka/views/USER/login_view.dart';

// +91 9999999990: bcc
// +91 1234567890: user

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  log("this is main");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jevlis ka?',
      theme: mainTheme,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const AuthApp(),
      ),
    ),
  );
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    log("this is auth app");
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInUser) {
          return const UserApp();
        } else if (state is AuthStateLoggedInCanteen) {
          return const CanteenApp();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("this is user app");
    return MaterialApp.router(
      routerConfig: userRouter,
      theme: mainTheme,
      title: "Jevlis Ka?",
    );
  }
}

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("this is canteen app");

    return MaterialApp.router(
      theme: mainTheme,
      routerConfig: canteenAdminRouter,
      title: "Jevlis Ka - Canteen Admin App",
    );
  }
}
