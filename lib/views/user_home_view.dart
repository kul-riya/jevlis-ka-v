import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/bottom_navbar_google.dart';
import 'package:jevlis_ka/constants/routes.dart';
// import 'package:jevlis_ka/utilities/extensions/get_argument.dart';
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
  int _selectedpage = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // choose item screen
      CanteenMenuView(
        canteenId: widget.canteenId,
        name: widget.name,
      ),

      // cart screen
      ViewCartView(
        canteenId: widget.canteenId,
      ),
    ];

    final List<String> titles = ['Menu ${widget.name}', 'Your Cart'];

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
            Navigator.of(context)
                .pushNamedAndRemoveUntil(chooseCanteenRoute, (route) => false);
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
  }
}
