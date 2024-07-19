import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class ViewCartView extends StatefulWidget {
  final Iterable<MenuItem> allMenuItems;
  final Cart? userCart;
  final String canteenId;
  final String canteenName;
  const ViewCartView(
      {super.key,
      required this.allMenuItems,
      required this.userCart,
      required this.canteenId,
      required this.canteenName});

  @override
  State<ViewCartView> createState() => _ViewCartViewState();
}

class _ViewCartViewState extends State<ViewCartView> {
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
    Cart userCart = widget.userCart ??
        Cart(
            cartItems: [],
            canteenId: widget.canteenId,
            canteenName: widget.canteenName,
            id: _canteenService.userId!,
            total: 0);
    final cartItems = userCart.cartItems;
    return Scaffold(
        body: (userCart.canteenId == widget.canteenId)
            ? Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems.elementAt(index);
                        final menuItem = allMenuItems
                            .where((menuItem) => menuItem.id == cartItem.id)
                            .first;
                        return CartItemWidget(
                          cartItem: cartItem,
                          menuItem: menuItem,
                          userCart: userCart,
                          onIconPress: (int incrementBy) {
                            _canteenService.addToCart(
                                menuItem,
                                incrementBy,
                                canteenId,
                                widget.canteenName,
                                userCart,
                                context);
                          },
                          onDelete: () {
                            _canteenService.deleteFromCart(menuItem, userCart);
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("No items from current canteen in cart"),
              ),
        bottomNavigationBar: userCart.cartItems.isEmpty
            ? null
            : Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -2),
                          blurRadius: 5)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Order Total",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            "₹ ${userCart.total}",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: ElevatedButton(
                            onPressed: () async {
                              await _canteenService.placeOrder(
                                  userCart: userCart);
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Order Placed successfully"),
                                      content: const Text(
                                          "You will be notified when order is ready"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"))
                                      ],
                                    );
                                  });
                            },
                            child: const Center(
                              child: Text("Checkout"),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ));
  }
}

typedef ItemToCartCallBack = void Function(int incrementBy);
typedef VoidCallback = void Function();

class CartItemWidget extends StatelessWidget {
  final CartMenuItem cartItem;
  final MenuItem menuItem;
  final Cart userCart;
  final ItemToCartCallBack onIconPress;
  final VoidCallback onDelete;

  const CartItemWidget(
      {super.key,
      required this.cartItem,
      required this.menuItem,
      required this.userCart,
      required this.onIconPress,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(3, 3), blurRadius: 3.0)
        ],
      ),
      child: ListTile(
        leading: SizedBox(
          width: 100,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: StorageImage(
              ref: FirebaseStorage.instance.ref(menuItem.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(menuItem.name),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                      ),
                      onPressed: () {
                        onIconPress(-1);
                      },
                    ),
                    Text(cartItem.quantity.toString()),
                    IconButton(
                        onPressed: () {
                          onIconPress(1);
                        },
                        icon: const Icon(Icons.add_circle_outline))
                  ],
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.deepOrange,
                size: 16,
              ),
              onPressed: () {
                onDelete();
              },
            ),
            Text('₹${(menuItem.price * cartItem.quantity).toString()}')
          ],
        ),
      ),
    );
  }
}
