import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/navigation/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  static const mainShellRoute = EmptyShellRoute('MainRoute');

  final AuthGuard authGuard;

  AppRouter({required this.authGuard}) : super();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, path: '/auth'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: ImageCropRoute.page),
    AutoRoute(
      page: mainShellRoute,
      initial: true,
      guards: [authGuard],
      children: [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          children: [
            AutoRoute(page: DashboardRoute.page, initial: true, path: 'dashboard'),
            AutoRoute(page: VenuesRoute.page, path: 'venues'),
            AutoRoute(page: OrdersRoute.page, path: 'orders'),
          ],
        ),
        AutoRoute(page: CartRoute.page, path: 'cart/:venueId'),
        AutoRoute(page: VenueDetailsRoute.page, usesPathAsKey: true, path: 'venues/:venueId'),
        AutoRoute(page: OrderDetailsRoute.page, usesPathAsKey: true, path: 'orders/:orderId'),
        AutoRoute(page: OrderChatRoute.page, path: 'orders/:orderId/chat', usesPathAsKey: true),
      ],
    ),
  ];
}
