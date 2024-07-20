import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/dialogs/generic_dialog.dart';

Future<bool> showDeleteItemDialog(BuildContext context,
    {required String name}) {
  return showGenericDialog<bool>(
    context: context,
    title: "Do you want to delete item: $name",
    content: "Action Cannot be undone",
    optionsBuilder: () => {'Yes': true, 'No': false},
  ).then((value) => value ?? false);
}
