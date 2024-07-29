import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_cart_service.dart';

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
  late final FirebaseCartService _cartService;

  @override
  void initState() {
    _cartService = FirebaseCartService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> allMenuItems = widget.allMenuItems.toList();
    allMenuItems.removeWhere((menuItem) => menuItem.isHidden);
    final String canteenId = widget.canteenId;
    final String canteenName = widget.canteenName;
    Cart userCart = widget.userCart ??
        Cart(
          cartItems: [],
          canteenId: canteenId,
          canteenName: canteenName,
          id: _cartService.userId!,
          total: 0,
        );
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 1.15,
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
            imageRef:
                _cartService.getImageReference(imagePath: menuItem.imagePath),
            userCart: userCart,
            canteenId: canteenId,
            onIconPress: (int incrementBy) {
              _cartService.addToCart(menuItem, incrementBy, canteenId,
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

    return LayoutBuilder(builder: (context, constraints) {
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
          children: [
            SizedBox(
              width: double.infinity,
              height: constraints.biggest.height * 0.7,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menuItem.name,
                                softWrap: true,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                "₹ ${menuItem.price}",
                                style: const TextStyle(
                                    fontSize: 11.5, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        onIconPress(-1);
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline)),
                                  Text(qty.toString()),
                                  IconButton(
                                      onPressed: () async {
                                        onIconPress(1);
                                      },
                                      icon:
                                          const Icon(Icons.add_circle_outline)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
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
