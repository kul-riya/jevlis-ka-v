import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jevlis_ka/constants/json_string_constants.dart';
import 'package:jevlis_ka/constants/routes.dart' show Constants;
import 'package:jevlis_ka/models/canteen_model.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCanteenService {
  final canteens = FirebaseFirestore.instance.collection('Canteens');
  final menuItems = FirebaseFirestore.instance.collection('MenuItems');
  final usersCarts = FirebaseFirestore.instance.collection('UsersCarts');
  final users = FirebaseFirestore.instance.collection('Users');

  String? get userId => FirebaseAuthProvider().currentUser?.uid;

// Miscellaneous

  // returns image reference on creating storage bucket
  Reference getImageReference({required String imagePath}) =>
      FirebaseStorage.instance.ref(imagePath);

  // return false if logged in user is NOT an admin, and true if logged in user is consumer
  Future<bool> getAdminCanteenId({required String uid}) async {
    DocumentSnapshot snapshot = await users.doc(uid).get();
    return snapshot[adminCanteenId] == null ? false : true;
  }

  // adds consumer users to firebase on email registration
  Future<void> addToUsers({required String uid}) async {
    await users.doc(uid).set({adminCanteenId: null});
  }

// Getting Streams of data

  Stream<Iterable<Canteen>> getCanteens() => canteens
      .snapshots()
      .map((event) => event.docs.map((doc) => Canteen.fromSnapshot(doc)));

  Stream<Iterable<MenuItem>> getMenuItems({required String canteenId}) =>
      menuItems.snapshots().map((event) => event.docs
          .map((doc) => MenuItem.fromSnapshot(doc))
          .where((item) => item.canteenId == canteenId));

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCart() =>
      usersCarts.doc(userId).snapshots();

// USER CART
  // Cart functionality

  Future<void> addToCart(MenuItem item, int incrementBy, String canteenId,
      String canteenName, Cart userCart, BuildContext context) async {
    if ((userCart.canteenId != canteenId) && (userCart.cartItems.isNotEmpty)) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "You have items saved in cart from \n ${userCart.canteenName} canteen"),
              content: const Text("Do you wish to empty your cart?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
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
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(Constants.chooseCanteenRoute);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            );
          },
          barrierDismissible: true);
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
        'total': userCart.total - (cartItem.price * cartItem.quantity)
      });
    } catch (e) {
      throw CouldNotDeleteCartItemsException();
    }
  }

  static final FirebaseCanteenService _shared =
      FirebaseCanteenService._sharedInstance();
  FirebaseCanteenService._sharedInstance();
  factory FirebaseCanteenService() => _shared;
}
