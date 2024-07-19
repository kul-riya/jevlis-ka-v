import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GBottomNavBarCanteen extends StatelessWidget {
  final void Function(int)? onTabChange;
  const GBottomNavBarCanteen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: GNav(
          color: Colors.deepOrange.shade500,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.deepOrange,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 12,
          iconSize: 24,
          hoverColor: Colors.transparent,
          gap: 8.0,
          onTabChange: onTabChange,
          tabs: const [
            GButton(
              icon: Icons.list_rounded,
              text: 'Order Log',
            ),
            GButton(
              icon: Icons.fastfood,
              text: 'Edit Menu',
            ),
            GButton(
              icon: Icons.history_rounded,
              text: 'Order History',
            )
          ],
        ),
      ),
    );
  }
}
