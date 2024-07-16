import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class CanteenMenuView extends StatefulWidget {
  final String canteenId;
  final Iterable<MenuItem> allMenuItems;
  final Cart? userCart;
  final String canteenName;

  const CanteenMenuView(
      {super.key,
      required this.allMenuItems,
      this.userCart,
      required this.canteenId,
      required this.canteenName});

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
    final Iterable<MenuItem> allMenuItems = widget.allMenuItems;
    final String canteenId = widget.canteenId;
    final String canteenName = widget.canteenName;
    Cart userCart = widget.userCart ??
        Cart(
          cartItems: [],
          canteenId: canteenId,
          canteenName: canteenName,
          id: _canteenService.userId!,
          total: 0,
        );
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.4,
          childAspectRatio: 1,
          crossAxisSpacing: 50,
          mainAxisSpacing: 50),
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 5,
      itemCount: allMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = allMenuItems.elementAt(index);
        return GestureDetector(
          child: MenuItemCard(
            menuItem: menuItem,
            imageRef: _canteenService.getImageReference(
                imagePath: menuItem.imagePath),
            userCart: userCart,
            canteenId: canteenId,
            onIconPress: (int incrementBy) {
              _canteenService.addToCart(menuItem, incrementBy, canteenId,
                  canteenName, userCart, context);
            },
          ),
          onTap: () {},
        );
      },
    );
  }
}

// TODO: create item desciption when ItemCallback is called ontap

typedef ItemToCartCallBack = void Function(int incrementBy);

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final Reference imageRef;
  final String canteenId;
  final Cart userCart;
  final ItemToCartCallBack onIconPress;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.imageRef,
    required this.userCart,
    required this.canteenId,
    required this.onIconPress,
  });

  @override
  Widget build(BuildContext context) {
    int qty = userCart.cartItems
        .where((element) => element.id == menuItem.id)
        .fold<int>(
            0, (previousValue, element) => previousValue + element.quantity);
    print("quantity recorded");

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36), topRight: Radius.circular(36.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 2.0, offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36.0)),
              child: StorageImage(
                ref: imageRef,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      menuItem.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      '₹ ${menuItem.price}',
                      style:
                          const TextStyle(fontSize: 11.5, color: Colors.grey),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                      ),
                      onPressed: () async {
                        onIconPress(-1);
                      },
                    ),
                    Text(qty.toString()),
                    IconButton(
                        onPressed: () {
                          onIconPress(1);
                        },
                        icon: const Icon(Icons.add_circle_outline))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class PhotoClipper extends CustomClipper<Rect> {
//   @override
//   Rect getClip(Size size) {
//     return Rect.fromLTWH(0, 0, size.width, size.height / 2);
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
// }
