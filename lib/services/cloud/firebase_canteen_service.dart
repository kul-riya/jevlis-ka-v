import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jevlis_ka/models/canteen_model.dart';
// import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';

class FirebaseCanteenService {
  final canteens = FirebaseFirestore.instance.collection('Canteens');
  final menuItems = FirebaseFirestore.instance.collection('MenuItems');
  final usersCarts = FirebaseFirestore.instance.collection('UsersCarts');

  final String? userId = FirebaseAuthProvider().currentUser?.uid;

  // creating storage bucket and it's reference

  Reference getImageReference({required String imagePath}) =>
      FirebaseStorage.instance.ref(imagePath);

  Stream<Iterable<Canteen>> getCanteens() => canteens
      .snapshots()
      .map((event) => event.docs.map((doc) => Canteen.fromSnapshot(doc)));

  Stream<Iterable<MenuItem>> getMenuItems({required String canteenId}) =>
      menuItems.snapshots().map((event) => event.docs
          .map((doc) => MenuItem.fromSnapshot(doc))
          .where((item) => item.canteenId == canteenId));

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCart() =>
      usersCarts.doc(userId).snapshots();

  // Future<String> getCartCanteenId() =>
  //     usersCarts.doc(userId).get().then((value) => Cart.fromSnapshot(value));

  // Future<Cart> getCart() async {
  //   final cartsnap = await usersCarts.doc(userId).get();
  //   return Cart.fromSnapshot(cartsnap);
  // }

  static final FirebaseCanteenService _shared =
      FirebaseCanteenService._sharedInstance();
  FirebaseCanteenService._sharedInstance();
  factory FirebaseCanteenService() => _shared;
}
