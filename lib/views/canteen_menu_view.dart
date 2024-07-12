import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class CanteenMenuView extends StatefulWidget {
  final String canteenId;
  final String name;
  const CanteenMenuView(
      {super.key, required this.canteenId, required this.name});

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
    final String canteenIdhere = widget.canteenId;
    return Scaffold(
        body: StreamBuilder(
      stream: _canteenService.getMenuItems(canteenId: canteenIdhere),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
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

  final FirebaseCanteenService _canteenService = FirebaseCanteenService();

  MenuItemList({super.key, required this.menuItems, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, crossAxisSpacing: 50, mainAxisSpacing: 50),
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 5,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems.elementAt(index);
        return GestureDetector(
          child: MenuItemCard(
              name: menuItem.name,
              price: menuItem.price,
              imageRef: _canteenService.getImageReference(
                  imagePath: menuItem.imagePath)),
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
  final Reference imageRef;
  const MenuItemCard(
      {super.key,
      required this.name,
      required this.price,
      required this.imageRef});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 2.0, offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 250,
            height: 180,
            child: ClipRect(
              // clipper: PhotoClipper(),
              child: StorageImage(
                ref: imageRef,
                fit: BoxFit.fitWidth,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PhotoClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height / 2);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
