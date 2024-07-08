import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class CanteenMenuView extends StatefulWidget {
  final String? canteenId;
  const CanteenMenuView({super.key, required this.canteenId});

  @override
  State<CanteenMenuView> createState() => _CanteenMenuViewState();
}

class _CanteenMenuViewState extends State<CanteenMenuView> {
  late final FirebaseCanteenService _canteenService;

  @override
  void initState() {
    _canteenService = FirebaseCanteenService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String canteenId = widget.canteenId ?? '';
    return Scaffold(
        body: StreamBuilder(
      stream: _canteenService.getMenuItems(canteenId: canteenId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              final allMenuItems = snapshot.data as Iterable<MenuItem>;
              return MenuItemList(
                menuItems: allMenuItems,
                onTap: (itemId) {},
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}

// TODO: create item desciption when ItemCallback is called ontap
typedef ItemCallBack = void Function(String itemId);

class MenuItemList extends StatelessWidget {
  final Iterable<MenuItem> menuItems;
  final ItemCallBack onTap;

  const MenuItemList({super.key, required this.menuItems, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
      ),
      padding: const EdgeInsets.all(12),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 5,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems.elementAt(index);
        return GestureDetector(
          child: MenuItemCard(
              name: menuItem.name,
              price: menuItem.price,
              imagePath: menuItem.imagePath),
          onTap: () {
            onTap(menuItem.id);
          },
        );
      },
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;
  const MenuItemCard(
      {super.key,
      required this.name,
      required this.price,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 5)]),
      child: Center(
        child: Text(
          name,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
