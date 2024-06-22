import 'package:flutter/material.dart';
// import 'package:jevlis_ka/views/login_view.dart';
import 'package:jevlis_ka/views/register_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Food App',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange, brightness: Brightness.light),
      useMaterial3: false,
    ),
    home: const RegisterView(),
  ));
}
