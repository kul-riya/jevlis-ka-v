import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class MenuItem {
  final String id;
  final String name;
  final double price;
  final String canteenId;
  final String imagePath;
  final String category;
  final bool isHidden;
  final bool isVeg;

  const MenuItem(
      {required this.category,
      required this.isHidden,
      required this.isVeg,
      required this.imagePath,
      required this.id,
      required this.name,
      required this.price,
      required this.canteenId});

  MenuItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        price = snapshot.data()['price'],
        canteenId = snapshot.data()['canteenId'],
        imagePath = snapshot.data()['imagePath'],
        category = snapshot.data()['category'],
        isHidden = snapshot.data()['isHidden'],
        isVeg = snapshot.data()['isVeg'];

  Map<String, dynamic> toJson() => {
        'canteenId': canteenId,
        'category': category,
        'imagePath': imagePath,
        'isHidden': isHidden,
        'isVeg': isVeg,
        'price': price,
        'name': name,
      };
}
