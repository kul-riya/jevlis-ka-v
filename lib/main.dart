import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/auth/bloc/auth_state.dart';
import 'package:jevlis_ka/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/views/canteen_menu_view.dart';
import 'package:jevlis_ka/views/choose_canteen_view.dart';
import 'package:jevlis_ka/views/login_view.dart';
import 'package:jevlis_ka/views/register_view.dart';
import 'package:jevlis_ka/views/view_cart_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Food App',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange, brightness: Brightness.light),
      useMaterial3: false,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const UserApp(),
    ),
    routes: {
      '/login_view/': (context) => const LoginView(),
      '/register_view/': (context) => const RegisterView(),
      chooseCanteenRoute: (context) => const ChooseCanteenView(),
      chooseItemRoute: (context) => const CanteenMenuView(),
      cartRoute: (context) => const ViewCartView(),
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
