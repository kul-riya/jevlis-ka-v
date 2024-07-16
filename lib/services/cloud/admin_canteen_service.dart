import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdminService {
  final orders = FirebaseFirestore.instance.collection('Orders');

  // Future<void> placeOrder

  static final FirebaseAdminService _shared =
      FirebaseAdminService._sharedInstance();
  FirebaseAdminService._sharedInstance();
  factory FirebaseAdminService() => _shared;
}
