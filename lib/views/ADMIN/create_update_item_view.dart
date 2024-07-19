import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';

class CreateUpdateItemView extends StatefulWidget {
  final MenuItem item;
  const CreateUpdateItemView({super.key, required this.item});

  @override
  State<CreateUpdateItemView> createState() => _CreateUpdateItemViewState();
}

class _CreateUpdateItemViewState extends State<CreateUpdateItemView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
