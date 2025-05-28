// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
// import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
// import 'package:jevlis_ka/components/registration_screens/register_login_button.dart';
// import 'package:jevlis_ka/components/registration_screens/register_text_field.dart';

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;

//   @override
//   void initState() {
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: Add exception handling using bloclistener
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Padding(
//         padding: const EdgeInsets.all(96.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "C R E A T E   A C C O U N T",
//               style: Theme.of(context).textTheme.displaySmall,
//             ),
//             const SizedBox(
//               height: 90,
//             ),
//             RegisterTextField(
//                 hintText: "Email",
//                 obscureText: false,
//                 controller: _emailController),
//             RegisterTextField(
//                 hintText: "Password",
//                 obscureText: true,
//                 controller: _passwordController),
//             RegisterLoginButton(
//               color: Theme.of(context).colorScheme.secondary,
//               text: "Continue",
//               onPressed: () async {
//                 final email = _emailController.text;
//                 final password = _passwordController.text;
//                 context
//                     .read<AuthBloc>()
//                     .add(AuthEventRegister(email: email, password: password));
//               },
//             ),
//             const Padding(padding: EdgeInsets.all(10.0), child: Text("Or")),
//             RegisterLoginButton(
//                 color: Theme.of(context).colorScheme.secondary,
//                 text: "Sign Up with Google",
//                 onPressed: () {
//                   context
//                       .read<AuthBloc>()
//                       .add(const AuthEventGoogleLoginUser());
//                 }),
//             const Padding(
//                 padding: EdgeInsets.only(top: 20.0, bottom: 7.0),
//                 child: Text("Already Registered?")),
//             RegisterLoginButton(
//               color: Theme.of(context).colorScheme.tertiary,
//               text: "Go to login View",
//               onPressed: () {
//                 context.read<AuthBloc>().add(AuthEventLogOut());
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
