import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  OrderItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'price': price, 'quantity': quantity};
}

class CanteenOrder {
  final String id;
  final String canteenId;
  final String canteenName;
  final String orderStatus;
  final List<OrderItem> orderItems;
  final Timestamp orderPlacingTime;
  final String userId;
  final double totalPrice;

  CanteenOrder(
      {required this.canteenName,
      required this.canteenId,
      required this.id,
      required this.orderStatus,
      required this.orderItems,
      required this.orderPlacingTime,
      required this.userId,
      required this.totalPrice});

  CanteenOrder.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        canteenId = snapshot.data()['canteenId'],
        canteenName = snapshot.data()['canteenName'],
        orderStatus = snapshot.data()['orderStatus'],
        orderItems = (snapshot.data()['orderItems'] as List<dynamic>)
            .map((orderItem) => OrderItem.fromJson(orderItem))
            .toList(),
        orderPlacingTime = snapshot.data()['orderPlacingTime'],
        userId = snapshot.data()['userId'],
        totalPrice = snapshot.data()['totalPrice'];

  Map<String, dynamic> toJson() => {
        'orderStatus': orderStatus,
        'canteenId': canteenId,
        'canteenName': canteenName,
        'orderItems':
            orderItems.map((orderItem) => orderItem.toJson()).toList(),
        'orderPlacingTime': orderPlacingTime.toString(),
        'userId': userId,
        'totalPrice': totalPrice,
      };
}
