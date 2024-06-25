import 'package:flutter/material.dart';
import 'package:jevlis_ka/auth/auth_service.dart';
import 'package:jevlis_ka/utilities/registration_screens/register_login_button.dart';
import 'package:jevlis_ka/utilities/registration_screens/register_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                "C R E A T E   A C C O U N T",
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
              RegisterLoginButton(
                text: "Continue",
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  await FirebaseAuthService.firebase()
                      .createUser(email: email, password: password);
                },
              ),
              const Padding(padding: EdgeInsets.all(10.0), child: Text("Or")),
              RegisterLoginButton(
                  text: "Sign Up with Google", onPressed: () {}),
              const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 7.0),
                  child: Text("Already Registered?")),
              RegisterLoginButton(text: "Login", onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
