import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jevlis_ka/components/bottom_navbar_google.dart';
import 'package:jevlis_ka/models/cart_model.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/cloud/firebase_canteen_service.dart';
import 'package:jevlis_ka/views/USER/canteen_menu_view.dart';
import 'package:jevlis_ka/views/USER/view_cart_view.dart';

class UserHomeView extends StatefulWidget {
  final String canteenId;
  final String canteenName;

  const UserHomeView(
      {super.key, required this.canteenId, required this.canteenName});

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
    final List<String> titles = ['Menu ${widget.canteenName}', 'Your Cart'];
    final String canteenId = widget.canteenId;
    final String canteenName = widget.canteenName;

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
                        userCart: cartSnapshot.data!.data() == null
                            ? null
                            : Cart.fromSnapshot(cartSnapshot.data!),
                        canteenId: canteenId,
                        canteenName: canteenName,
                      ),

                      // cart screen
                      ViewCartView(
                        allMenuItems:
                            menuItemsSnapshot.data as Iterable<MenuItem>,
                        userCart: cartSnapshot.data!.data() == null
                            ? null
                            : Cart.fromSnapshot(cartSnapshot.data!),
                        canteenId: canteenId,
                        canteenName: canteenName,
                      ),
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
                          icon: const Icon(
                            Icons.restaurant_menu,
                            size: 30,
                          ),
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventInitialize());
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
