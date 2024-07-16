import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_state.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/theme/theme.dart';
import 'package:jevlis_ka/views/ADMIN/canteen_home_view.dart';
import 'package:jevlis_ka/views/USER/choose_canteen_view.dart';
import 'package:jevlis_ka/views/USER/login_view.dart';
import 'package:jevlis_ka/views/USER/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Jevlis ka?',
    theme: mainTheme,
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const AuthApp(),
    ),
  ));
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInUser) {
          return const UserApp();
        } else if (state is AuthStateLoggedInCanteen) {
          return const CanteenApp();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
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
    return const ChooseCanteenView();
  }
}

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CanteenHomeView();
  }
}
