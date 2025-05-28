import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_cart_service.dart';

class FavouritesView extends StatefulWidget {
  final Iterable<MenuItem> allMenuItems;
  final Cart userCart;
  const FavouritesView(
      {super.key, required this.allMenuItems, required this.userCart});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  late final FirebaseCartService _cartService;

  @override
  void initState() {
    _cartService = FirebaseCartService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = widget.allMenuItems.toList();
    return StreamBuilder(
        stream: _cartService.likes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final likes = snapshot.data!['likes'] as List<dynamic>;
            if (likes.isEmpty) {
              return const Center(
                child: Text("You have no liked items"),
              );
            }
            return ListView.builder(
              itemCount: likes.length,
              itemBuilder: (context, index) {
                final menuItem = menuItems
                    .firstWhere((element) => element.id == likes[index]);
                return LikedItemTile(
                  menuItem: menuItem,
                  imageRef: _cartService.getImageReference(
                      imagePath: menuItem.imagePath),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class LikedItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final Reference imageRef;
  const LikedItemTile(
      {super.key, required this.menuItem, required this.imageRef});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.only(top: 12, left: 10, right: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(2, 2))
        ],
      ),
      child: ListTile(
        isThreeLine: true,
        leading: ClipRRect(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: StorageImage(ref: imageRef),
          ),
        ),
        title: Text(menuItem.name),
        subtitle: Text("₹ ${menuItem.price.toString()}"),
        trailing: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_circle_outline)),
            Text(),
          ],
        ),
      ),
    );
  }
}
