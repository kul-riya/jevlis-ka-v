import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jevlis_ka/components/dialogs/empty_cart_dialog.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCartService {
  final users = FirebaseFirestore.instance.collection('Users');
  final orders = FirebaseFirestore.instance.collection('Orders');
  final usersCarts = FirebaseFirestore.instance.collection('UsersCarts');

  String? get userId => FirebaseAuthProvider().currentUser?.uid;

  Reference getImageReference({required String imagePath}) =>
      FirebaseStorage.instance.ref(imagePath);

  Future<void> addToCart(MenuItem item, int incrementBy, String canteenId,
      String canteenName, Cart userCart, BuildContext context) async {
    if ((userCart.canteenId != canteenId) && (userCart.cartItems.isNotEmpty)) {
      bool shouldEmptyCart =
          await emptyCartDialog(context, canteenName: userCart.canteenName);
      if (shouldEmptyCart) {
        try {
          await usersCarts.doc(userId).set(Cart(
                  cartItems: [],
                  canteenId: canteenId,
                  canteenName: canteenName,
                  id: userId!,
                  total: 0)
              .toJson());
        } catch (e) {
          throw CouldNotCreateCartException();
        }
      } else {
        context.go(Constants.chooseCanteenRoute);
      }
    } else {
      userCart.canteenId = canteenId;
      userCart.canteenName = canteenName;
      CartMenuItem? cartItem = userCart.cartItems
          .where((cartItem) => cartItem.id == item.id)
          .firstOrNull;
      if (cartItem == null) {
        incrementBy == 1
            ? userCart.cartItems.add(CartMenuItem(
                id: item.id,
                quantity: incrementBy,
                name: item.name,
                price: item.price))
            : null;
      } else {
        cartItem.quantity += incrementBy;
        if (cartItem.quantity == 0) {
          userCart.cartItems.remove(cartItem);
        }
      }
      userCart.total += (incrementBy * item.price);
      try {
        await usersCarts.doc(userCart.id).set(userCart.toJson());
      } catch (e) {
        throw CouldNotUpdateCartException();
      }
    }
  }

  Future<void> deleteFromCart(MenuItem item, Cart userCart) async {
    final cartItem =
        userCart.cartItems.where((cartItem) => cartItem.id == item.id).first;
    try {
      await usersCarts.doc(userCart.id).update({
        'cartItems': FieldValue.arrayRemove([cartItem.toJson()]),
        'total': userCart.total - (item.price * cartItem.quantity)
      });
    } catch (e) {
      throw CouldNotDeleteCartItemsException();
    }
  }

  // on checkout
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

  static final FirebaseCartService _shared =
      FirebaseCartService._sharedInstance();
  FirebaseCartService._sharedInstance();
  factory FirebaseCartService() => _shared;
}
