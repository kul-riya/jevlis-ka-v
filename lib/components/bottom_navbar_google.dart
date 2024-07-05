import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyGBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyGBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: GNav(
          color: Colors.deepOrange.shade500,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.deepOrange,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 12,
          iconSize: 24,
          tabMargin: const EdgeInsets.symmetric(horizontal: 12),
          hoverColor: Colors.transparent,
          gap: 8.0,
          onTabChange: onTabChange,
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Order',
            ),
            GButton(
              icon: Icons.shopping_cart_rounded,
              text: 'Cart',
            )
          ],
        ),
      ),
    );
  }
}
