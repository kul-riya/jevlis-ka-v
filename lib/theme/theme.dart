import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        background: Colors.deepOrange.shade800,
        primary: Colors.deepOrange.shade200,
        secondary: Colors.white38,
        tertiary: Colors.white24),
    useMaterial3: false,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
    ));
