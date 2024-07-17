import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/services/cloud/cloud_storage_exceptions.dart';

class FirebaseAdminService {
  final orders = FirebaseFirestore.instance.collection('Orders');
  final usersCarts = FirebaseFirestore.instance.collection('UsersCarts');

  Future<void> placeOrder({required Cart userCart}) async {
    final Map<String, dynamic> canteenOrderData = {
      'canteenId': userCart.canteenId,
      'canteenName': userCart.canteenName,
      'orderStatus': orderPlaced,
      'orderPlacingTime': DateTime.now(),
      'orderItems': userCart.cartItems.map((cartItem) => cartItem.toJson()),
      'userId': userCart.id,
      'totalPrice': userCart.total,
    };

    print(canteenOrderData);

    try {
      await orders.doc().set(canteenOrderData);
    } catch (e) {
      throw CouldNotPlaceOrderException();
    }
    try {
      await usersCarts.doc(userCart.id).delete();
    } catch (e) {
      throw CouldNotDeleteCartException();
    }
  }

  static final FirebaseAdminService _shared =
      FirebaseAdminService._sharedInstance();
  FirebaseAdminService._sharedInstance();
  factory FirebaseAdminService() => _shared;
}
