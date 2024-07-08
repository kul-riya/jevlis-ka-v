import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
// import 'package:jevlis_ka/auth/auth_exceptions.dart';
import 'package:jevlis_ka/utilities/registration_screens/register_login_button.dart';
import 'package:jevlis_ka/utilities/registration_screens/register_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add exception handling using bloclistener
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(96.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "L O G   I N   T O   A C C O U N T",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 90,
            ),
            RegisterTextField(
                hintText: "Email",
                obscureText: false,
                controller: _emailController),
            RegisterTextField(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController),
            RegisterLoginButton(
              color: Theme.of(context).colorScheme.secondary,
              text: "Continue",
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                context.read<AuthBloc>().add(
                    AuthEventEmailLoginUser(email: email, password: password));
              },
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Or",
                  style: Theme.of(context).textTheme.titleSmall,
                )),
            RegisterLoginButton(
                color: Theme.of(context).colorScheme.secondary,
                text: "Sign In with Google",
                onPressed: () async {
                  context.read<AuthBloc>().add(AuthEventGoogleLoginUser());
                }),
            const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 7.0),
                child: Text("Not Registered Yet?")),
            RegisterLoginButton(
              color: Theme.of(context).colorScheme.tertiary,
              text: "Register Now",
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventShouldRegister());
              },
            )
          ],
        ),
      ),
    );
  }
}
