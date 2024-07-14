import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';

class ViewCartView extends StatefulWidget {
  final Iterable<MenuItem> allMenuItems;
  final Cart userCart;
  const ViewCartView(
      {super.key, required this.allMenuItems, required this.userCart});

  @override
  State<ViewCartView> createState() => _ViewCartViewState();
}

class _ViewCartViewState extends State<ViewCartView> {
  @override
  Widget build(BuildContext context) {
    final cartItems = widget.userCart.cartItems;
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return CartItemWidget(cartItem: cartItems.elementAt(index));
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartMenuItem? cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cartItem?.id ?? ''),
    );
  }
}
