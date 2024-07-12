import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jevlis_ka/models/canteen_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCanteenService {
  final canteens = FirebaseFirestore.instance.collection('Canteens');
  final menuItems = FirebaseFirestore.instance.collection('MenuItems');

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
}
