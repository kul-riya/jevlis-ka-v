import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterLoginButton extends StatelessWidget {
  RegisterLoginButton({super.key, required this.text, required this.onPressed});

  final String text;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0))),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(60)),
            backgroundColor: MaterialStateProperty.all(Colors.white10)),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
        ));
  }
}
