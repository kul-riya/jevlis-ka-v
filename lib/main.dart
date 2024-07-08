import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_state.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/theme/theme.dart';
import 'package:jevlis_ka/views/choose_canteen_view.dart';
// import 'package:jevlis_ka/views/choose_canteen_screen.dart';
import 'package:jevlis_ka/views/user_home_view.dart';
import 'package:jevlis_ka/views/login_view.dart';
import 'package:jevlis_ka/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Food App',
    theme: mainTheme,
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const UserApp(),
    ),
    routes: {
      chooseCanteenRoute: (context) => const ChooseCanteenView(),
      userHomeRoute: (context) => const UserHomeView(),
    },
  ));
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedInUser) {
          // TODO: create auth state with canteen id as parameter
          // to directly open canteen menu view

          return const ChooseCanteenView();
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

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
