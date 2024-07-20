import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
  fontFamily: 'Montserrat',
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
        fontWeight: FontWeight.w100,
        fontFamily: 'Sunborn',
        fontSize: 28,
        color: Colors.black87),
    titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Sunborn',
        color: Colors.black),
    labelLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0),
    headlineSmall: TextStyle(
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
        color: Colors.white,
        fontFamily: 'Sunborn',
        fontWeight: FontWeight.w100),
    labelSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
    labelMedium: TextStyle(fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w300),
  ),
);
