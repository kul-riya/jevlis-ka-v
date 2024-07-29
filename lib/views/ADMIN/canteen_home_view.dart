import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jevlis_ka/components/bottom_navbars_google/canteen.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_bloc.dart';
import 'package:jevlis_ka/services/auth/bloc/auth_event.dart';
import 'package:jevlis_ka/services/auth/firebase_auth_provider.dart';
import 'package:jevlis_ka/services/cloud/firebase_admin_service.dart';
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

  List<String> titles = ['Order Log', 'Edit Menu', 'Order History'];

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
              EditMenuItemView(
                adminCanteenId: snapshot.data!,
              ),

              // Order History View
              OrderHistoryView(
                adminCanteenId: snapshot.data!,
              ),
            ];
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: Text(titles[_selectedpage]),
              ),
              endDrawer: Drawer(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        DrawerHeader(
                          child: StorageImage(
                            ref: _adminService.getImageReference(
                                imagePath:
                                    "gs://jevlis-ka-part2.appspot.com/hat_logo_white-removebg-preview.png"),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Settings",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.alarm_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Manage Timings",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {},
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, bottom: 24.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                            ),
                            title: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              context.read<AuthBloc>().add(AuthEventLogOut());
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
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
