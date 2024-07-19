import 'package:flutter/material.dart';
import 'package:jevlis_ka/components/bottom_navbars_google/canteen.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/services/cloud/admin_canteen_service.dart';
import 'package:jevlis_ka/views/ADMIN/edit_menu_item_view.dart';
import 'package:jevlis_ka/views/ADMIN/log_view.dart';
import 'package:jevlis_ka/views/ADMIN/order_history.dart';

class CanteenHomeView extends StatefulWidget {
  const CanteenHomeView({super.key});

  @override
  State<CanteenHomeView> createState() => _CanteenHomeViewState();
}

class _CanteenHomeViewState extends State<CanteenHomeView> {
  late final FirebaseAdminService _adminService;
  final FirebaseAuthProvider provider = FirebaseAuthProvider();
  late String adminCanteenId;

  int _selectedpage = 0;

  @override
  void initState() {
    _adminService = FirebaseAdminService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _adminService.getAdminCanteenId(uid: provider.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Widget> pages = [
              // Canteen Log View
              OrderLogView(adminCanteenId: snapshot.data!),

              // Edit menu view
              const EditMenuItemView(),

              // Order History View
              const OrderHistoryView(),
            ];
            return Scaffold(
              body: pages[_selectedpage],
              bottomNavigationBar: GBottomNavBarCanteen(
                onTabChange: (index) {
                  setState(() {
                    _selectedpage = index;
                  });
                },
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
