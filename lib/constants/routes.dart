import 'package:go_router/go_router.dart';
import 'package:jevlis_ka/models/menu_item_model.dart';
import 'package:jevlis_ka/views/ADMIN/canteen_home_view.dart';
import 'package:jevlis_ka/views/ADMIN/edit_menu_item_view.dart';
import 'package:jevlis_ka/views/USER/choose_canteen_view.dart';
import 'package:jevlis_ka/views/USER/user_home_view.dart';

class Constants {
// Route String constants
  // UserApp
  static const String chooseCanteenRoute = '/choose-canteen';
  String userHomeRoute(String canteenId) => '/user-home/$canteenId';

  // CanteenApp
  static const String canteenHomeRoute = '/canteen-home';
  String editMenuItemRoute(String itemId) => 'edit-item/$itemId';
}

// GoRouters
final userRouter = GoRouter(
  initialLocation: Constants.chooseCanteenRoute,
  routes: [
    GoRoute(
        path: Constants.chooseCanteenRoute,
        name: 'dis first',
        builder: (context, state) => const ChooseCanteenView()),
    GoRoute(
      path: Constants().userHomeRoute(':canteenId'),
      name: 'dis rest',
      builder: (context, state) => UserHomeView(
          canteenId: state.pathParameters['canteenId']!,
          canteenName: (state.extra as Map)['name']),
    )
  ],
);

final canteenAdminRouter = GoRouter(
  initialLocation: Constants.canteenHomeRoute,
  routes: [
    GoRoute(
        path: Constants.canteenHomeRoute,
        name: 'home screen',
        builder: (context, state) => const CanteenHomeView(),
        routes: <RouteBase>[
          GoRoute(
            path: Constants().editMenuItemRoute(':itemId'),
            builder: (context, state) =>
                EditMenuItemView(item: (state.extra as MenuItem)),
          ),
        ]),
  ],
);
