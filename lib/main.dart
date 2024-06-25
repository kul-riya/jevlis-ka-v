import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/firebase_options.dart';
// import 'package:jevlis_ka/views/login_view.dart';
import 'package:jevlis_ka/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange, brightness: Brightness.light),
        useMaterial3: false,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return const RegisterView();
        });
  }
}
