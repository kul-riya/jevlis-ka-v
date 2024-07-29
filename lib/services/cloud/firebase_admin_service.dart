import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/models/order_model.dart';

class FirebaseAdminService {
  final orders = FirebaseFirestore.instance.collection('Orders');
  final users = FirebaseFirestore.instance.collection('Users');
  final menuItems = FirebaseFirestore.instance.collection('MenuItems');

  final String adminCanteenId = 'adminCanteenId';

  Future<String> getAdminCanteenId({required String uid}) async {
    DocumentSnapshot snapshot = await users.doc(uid).get();
    return snapshot[adminCanteenId];
  }

  Reference getImageReference({required String imagePath}) =>
      FirebaseStorage.instance.ref(imagePath);

  Stream<Iterable<CanteenOrder>> getOrders({required String adminCanteenId}) =>
      orders.snapshots().map((event) => event.docs
          .map((doc) => CanteenOrder.fromSnapshot(doc))
          .where((order) => order.canteenId == adminCanteenId));

  Future<void> updateOrderStatus(
      {required String orderId, required String orderStatus}) async {
    await orders.doc(orderId).update({'orderStatus': orderStatus});
  }

  Future<void> updateItem({required MenuItem item}) async {
    await menuItems.doc(item.id).set(item.toJson());
  }

  Future<void> deleteItem({required String id}) async {
    await menuItems.doc(id).delete();
  }

  static final FirebaseAdminService _shared =
      FirebaseAdminService._sharedInstance();
  FirebaseAdminService._sharedInstance();
  factory FirebaseAdminService() => _shared;
}
