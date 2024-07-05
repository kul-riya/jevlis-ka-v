import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/bottom_navbar_google.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/views/canteen_menu_view.dart';
import 'package:jevlis_ka/views/view_cart_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int _selectedpage = 0;

  final List<Widget> _pages = [
    // choose item screen
    const CanteenMenuView(),

    // cart screen
    const ViewCartView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pushNamed(chooseCanteenRoute);
          },
        ),
      ),
      body: _pages[_selectedpage],
      bottomNavigationBar: MyGBottomNavBar(
        onTabChange: (index) {
          setState(() {
            _selectedpage = index;
          });
        },
      ),
    );
  }
}
