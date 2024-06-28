import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/auth/auth_service.dart';
import 'package:jevlis_ka/constants/routes.dart';
// import 'package:jevlis_ka/auth/auth_service.dart';
import 'package:jevlis_ka/firebase_options.dart';
import 'package:jevlis_ka/views/canteen_menu_view.dart';
import 'package:jevlis_ka/views/choose_canteen_view.dart';
import 'package:jevlis_ka/views/login_view.dart';
// import 'package:jevlis_ka/views/login_view.dart';
import 'package:jevlis_ka/views/register_view.dart';
import 'package:jevlis_ka/views/view_cart_view.dart';

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
      home: const UserApp(),
      routes: {
        '/login_view/': (context) => const LoginView(),
        '/register_view/': (context) => const RegisterView(),
        chooseCanteenRoute: (context) => const ChooseCanteenView(),
        chooseItemRoute: (context) => const CanteenMenuView(),
        cartRoute: (context) => const ViewCartView(),
      },
    ),
  );
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                return const ChooseCanteenView();
              } else {
                return const LoginView();
              }
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        });
  }
}
