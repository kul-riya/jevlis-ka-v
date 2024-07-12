import 'package:flutter/foundation.dart';

@immutable
class CartMenuItem {
  final String id;
  final int quantity;
  final double cost;

  const CartMenuItem(
      {required this.id, required this.quantity, required this.cost});
}

class Cart {
  final List<CartMenuItem> cartItems;
  final String canteenId;
  final String id;

  Cart({required this.cartItems, required this.canteenId, required this.id});
}
