import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';

class EditMenuItemView extends StatefulWidget {
  final MenuItem item;
  const EditMenuItemView({super.key, required this.item});

  @override
  State<EditMenuItemView> createState() => _EditMenuItemViewState();
}

class _EditMenuItemViewState extends State<EditMenuItemView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
