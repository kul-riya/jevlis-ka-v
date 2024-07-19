import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/models/order_model.dart';

class FirebaseAdminService {
  final orders = FirebaseFirestore.instance.collection('Orders');
  final users = FirebaseFirestore.instance.collection('Users');

  final String adminCanteenId = 'adminCanteenId';

  Future<String> getAdminCanteenId({required String uid}) async {
    DocumentSnapshot snapshot = await users.doc(uid).get();
    return snapshot[adminCanteenId];
  }

  Stream<Iterable<CanteenOrder>> getOrders({required String adminCanteenId}) =>
      orders.snapshots().map((event) => event.docs
          .map((doc) => CanteenOrder.fromSnapshot(doc))
          .where((order) => order.canteenId == adminCanteenId));

  Future<void> makeOrderReady({required String orderId}) async {
    await orders.doc(orderId).update({'orderStatus': orderReady});
  }

  Future<void> makeOrderCancel({required String orderId}) async {
    await orders.doc(orderId).update({'orderStatus': orderCancelled});
  }

  static final FirebaseAdminService _shared =
      FirebaseAdminService._sharedInstance();
  FirebaseAdminService._sharedInstance();
  factory FirebaseAdminService() => _shared;
}
