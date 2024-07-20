import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/dialogs/generic_dialog.dart';

Future<bool> emptyCartDialog(BuildContext context,
    {required String canteenName}) {
  return showGenericDialog<bool>(
    context: context,
    title: "You have items saved in cart from \n $canteenName canteen",
    content: "Do you wish to empty your cart?",
    optionsBuilder: () => {'Yes': true, "No": false},
  ).then((value) => value ?? false);
}
