import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class MenuItem {
  final String id;
  final String name;
  final int price;
  final String canteenId;
  final String imagePath;

  const MenuItem(
      {required this.imagePath,
      required this.id,
      required this.name,
      required this.price,
      required this.canteenId});

  MenuItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        price = snapshot.data()['price'],
        canteenId = snapshot.data()['canteenId'],
        imagePath = snapshot.data()['imagePath'];
}
