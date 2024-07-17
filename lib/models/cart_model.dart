import 'package:cloud_firestore/cloud_firestore.dart';

class CartMenuItem {
  final String id;
  int quantity;
  final String name;
  final double price;

  CartMenuItem(
      {required this.name,
      required this.price,
      required this.id,
      required this.quantity});

  CartMenuItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'name': name,
        'price': price,
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
            .map((item) => CartMenuItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() => {
        'canteenId': canteenId,
        'canteenName': canteenName,
        'cartItems': cartItems.map((cartItem) => cartItem.toJson()).toList(),
        'total': total,
      };
}
