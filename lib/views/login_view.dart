import 'package:flutter/material.dart';
import 'package:jevlis_ka/utilities/register_login_button.dart';
import 'package:jevlis_ka/utilities/register_text_field.dart';

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(96.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "L O G   I N   T O   A C C O U N T",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
              RegisterLoginButton(text: "Continue", onPressed: () {}),
              const Padding(padding: EdgeInsets.all(10.0), child: Text("Or")),
              RegisterLoginButton(
                  text: "Sign In with Google", onPressed: () {}),
              const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 7.0),
                  child: Text("Not Registered Yet?")),
              RegisterLoginButton(text: "Register Now", onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
