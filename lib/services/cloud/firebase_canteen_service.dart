import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jevlis_ka/models/canteen_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCanteenService {
  final canteens = FirebaseFirestore.instance.collection('Canteens');
  final menuItems = FirebaseFirestore.instance.collection('MenuItems');
  final usersCarts = FirebaseFirestore.instance.collection('UsersCarts');
  final users = FirebaseFirestore.instance.collection('Users');

// Miscellaneous

  // returns image reference on creating storage bucket
  Reference getImageReference({required String imagePath}) =>
      FirebaseStorage.instance.ref(imagePath);

  // return false if logged in user is NOT an admin, and true if logged in user is consumer
  Future<String?> getAdminCanteenId({required String uid}) async {
    DocumentSnapshot snapshot = await users.doc(uid).get();
    return snapshot['adminCanteenId'];
  }

  // adds consumer users to firebase on email registration
  Future<void> addToUsers({required String uid}) async {
    DocumentReference docRef = users.doc(uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      await users.doc(uid).set({'adminCanteenId': null, "likes": []});
    }
  }

// Getting Streams of data

  Stream<Iterable<Canteen>> getCanteens() => canteens
      .snapshots()
      .map((event) => event.docs.map((doc) => Canteen.fromSnapshot(doc)));

  Stream<Iterable<MenuItem>> getMenuItems({required String canteenId}) =>
      menuItems.snapshots().map((event) => event.docs
          .map((doc) => MenuItem.fromSnapshot(doc))
          .where((item) => item.canteenId == canteenId));

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCart(
          {required String uid}) =>
      usersCarts.doc(uid).snapshots();

  Future<void> updateVisibility(bool isHidden, String itemId) async {
    await menuItems.doc(itemId).update({'isHidden': isHidden});
  }

  static final FirebaseCanteenService _shared =
      FirebaseCanteenService._sharedInstance();
  FirebaseCanteenService._sharedInstance();
  factory FirebaseCanteenService() => _shared;
}
