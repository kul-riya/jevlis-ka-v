import 'package:flutter/material.dart';

class RegisterTextField extends StatefulWidget {
  const RegisterTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
        ),
      ),
    );
  }
}
