import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/bottom_navbar_google.dart';
import 'package:jevlis_ka/constants/routes.dart';
import 'package:jevlis_ka/utilities/extensions/get_argument.dart';
import 'package:jevlis_ka/views/canteen_menu_view.dart';
import 'package:jevlis_ka/views/view_cart_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int _selectedpage = 0;

  @override
  Widget build(BuildContext context) {
    final canteenId = context.getArgument<String>();
    final List<Widget> pages = [
      // choose item screen
      CanteenMenuView(canteenId: canteenId),

      // cart screen
      const ViewCartView(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
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
