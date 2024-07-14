import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/bottom_navbar_google.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';
import 'package:jevlis_ka/views/canteen_menu_view.dart';
import 'package:jevlis_ka/views/view_cart_view.dart';

class UserHomeView extends StatefulWidget {
  final String canteenId;
  final String name;

  const UserHomeView({super.key, required this.canteenId, required this.name});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  late final FirebaseCanteenService _canteenService;
  int _selectedpage = 0;

  @override
  void initState() {
    _canteenService = FirebaseCanteenService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['Menu ${widget.name}', 'Your Cart'];

    return StreamBuilder(
        stream: _canteenService.getMenuItems(canteenId: widget.canteenId),
        builder: (context, menuItemsSnapshot) {
          if (menuItemsSnapshot.hasData) {
            return StreamBuilder(
                stream: _canteenService.getCart(),
                builder: (context, cartSnapshot) {
                  if (cartSnapshot.hasData) {
                    // build the pages
                    final List<Widget> pages = [
                      // choose item screen
                      CanteenMenuView(
                          allMenuItems:
                              menuItemsSnapshot.data as Iterable<MenuItem>,
                          userCart: Cart.fromSnapshot(cartSnapshot.data!)),

                      // cart screen
                      ViewCartView(
                          allMenuItems:
                              menuItemsSnapshot.data as Iterable<MenuItem>,
                          userCart: Cart.fromSnapshot(cartSnapshot.data!)),
                    ];
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.deepOrange,
                        title: Text(
                          titles[_selectedpage],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                chooseCanteenRoute, (route) => false);
                          },
                        ),
                      ),
                      body: pages[_selectedpage],
                      bottomNavigationBar: MyGBottomNavBar(
                        onTabChange: (index) {
                          setState(() {
                            _selectedpage = index;
                          });
                        },
                      ),
                    );
                  } else {
                    return const Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }
                });
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
