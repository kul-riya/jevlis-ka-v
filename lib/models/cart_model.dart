import 'package:cloud_firestore/cloud_firestore.dart';

class CartMenuItem {
  final String id;
  int quantity;

  CartMenuItem({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
      };
}

class Cart {
  List<CartMenuItem> cartItems;
  String canteenId;
  String canteenName;
  String id;
  double total;

  Cart(
      {required this.cartItems,
      required this.canteenId,
      required this.id,
      required this.total,
      required this.canteenName});

  Cart.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        canteenId = snapshot['canteenId'],
        canteenName = snapshot['canteenName'],
        total = snapshot['total'],
        cartItems = (snapshot['cartItems'] as Iterable<dynamic>)
            .map(
              (item) => CartMenuItem(
                id: item['id'],
                quantity: item['quantity'],
              ),
            )
            .toList();

  Map<String, dynamic> toJson() => {
        'canteenId': canteenId,
        'canteenName': canteenName,
        'cartItems': cartItems.map((cartItem) => cartItem.toJson()).toList(),
        'total': total,
      };
}
