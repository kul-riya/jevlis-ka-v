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
  static const String userHomeRoute = '/user-home/:canteenId';

  // CanteenApp
  static const String canteenHomeRoute = '/canteen-home';
  static const String editMenuItemRoute = 'edit-item/:itemId';
}

// GoRouters
final userRouter = GoRouter(
  initialLocation: Constants.canteenHomeRoute,
  routes: [
    GoRoute(
        path: Constants.canteenHomeRoute,
        name: 'dis first',
        builder: (context, state) => const ChooseCanteenView()),
    GoRoute(
      path: Constants.userHomeRoute,
      name: 'dis rest',
      builder: (context, state) => UserHomeView(
          canteenId: state.pathParameters['canteenId']!,
          canteenName: (state.extra as Map)['name']),
    )
  ],
);

final canteenAdminRouter = GoRouter(
  routes: [
    GoRoute(
        path: Constants.canteenHomeRoute,
        name: 'home screen',
        builder: (context, state) => const CanteenHomeView(),
        routes: <RouteBase>[
          GoRoute(
            path: Constants.editMenuItemRoute,
            builder: (context, state) =>
                EditMenuItemView(item: (state.extra as MenuItem)),
          ),
        ]),
  ],
);
