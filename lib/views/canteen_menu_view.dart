import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';

class CanteenMenuView extends StatefulWidget {
  final String? canteenId;
  const CanteenMenuView({super.key, required this.canteenId});

  @override
  State<CanteenMenuView> createState() => _CanteenMenuViewState();
}

class _CanteenMenuViewState extends State<CanteenMenuView> {
  @override
  Widget build(BuildContext context) {
    widget.canteenId;
    return const Scaffold(
      body: Center(
        child: Text("Canteen menu screen"),
      ),
    );
  }
}

// TODO: create item desciption when ItemCallback is called ontap
typedef ItemCallBack = void Function(String itemId);

class MenuItemList extends StatelessWidget {
  final Iterable<MenuItem> menuItems;

  const MenuItemList({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
