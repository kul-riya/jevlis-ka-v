import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Iterable<CartMenuItem> cartItems;
  final String canteenId;
  final String id;

  Cart({required this.cartItems, required this.canteenId, required this.id});

  Cart.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        canteenId = snapshot['canteenId'],
        cartItems = (snapshot['cartItems'] as Iterable<dynamic>).map(
          (item) => CartMenuItem(
            id: item['id'],
            quantity: item['quantity'],
            cost: item['cost'],
          ),
        );

  // create cart.tojson also
}
