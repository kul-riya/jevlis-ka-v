import 'package:flutter/material.dart';
import 'package:jevlis_ka/models/cart_model.dart';
// import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';

class ViewCartView extends StatefulWidget {
  final String canteenId;
  const ViewCartView({super.key, required this.canteenId});

  @override
  State<ViewCartView> createState() => _ViewCartViewState();
}

class _ViewCartViewState extends State<ViewCartView> {
  late final FirebaseCanteenService _canteenService;

  @override
  void initState() {
    _canteenService = FirebaseCanteenService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _canteenService.getMenuItems(canteenId: widget.canteenId),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: _canteenService.getCart(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userCart = Cart.fromSnapshot(snapshot.data!);
              final cartItems = userCart.cartItems;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemWidget(cartItem: cartItems.elementAt(index));
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartMenuItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cartItem.id),
    );
  }
}
