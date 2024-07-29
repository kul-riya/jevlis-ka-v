import 'package:flutter/material.dart';

Future<String?> getSmsCodeFromUser(BuildContext context) async {
  String? smsCode;
  await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter code"),
          content: TextField(
            onChanged: (value) {
              smsCode = value;
            },
            autofocus: true,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              onPressed: () {
                smsCode = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      });
  return smsCode;
}
