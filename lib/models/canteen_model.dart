import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Canteen {
  final String canteenId;
  final String name;
  final String imagePath;

  const Canteen(
      {required this.canteenId, required this.name, required this.imagePath});

  Canteen.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : canteenId = snapshot.id,
        name = snapshot.data()['name']!,
        imagePath = snapshot.data()['imagePath']!;
}
