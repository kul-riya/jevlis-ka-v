import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final String name;
  final double pricePerUnit;
  final int quantity;

  OrderItem(
      {required this.id,
      required this.name,
      required this.pricePerUnit,
      required this.quantity});

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        pricePerUnit = json['pricePerUnit'],
        quantity = json['quantity'];
}

class Order {
  final String id;
  final String orderStatus;
  final List<OrderItem> orderItems;
  final Timestamp orderPlacingTime;
  final String userId;
  final double totalPrice;

  Order(
      {required this.id,
      required this.orderStatus,
      required this.orderItems,
      required this.orderPlacingTime,
      required this.userId,
      required this.totalPrice});

  Order.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        orderStatus = snapshot.data()['orderStatus'],
        orderItems = (snapshot.data()['orderItems'] as List<dynamic>)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        orderPlacingTime = snapshot.data()['orderPlacingTime'],
        userId = snapshot.data()['userId'],
        totalPrice = snapshot.data()['totalPrice'];
}
