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
        AutoRoute(page: AuthRoute.page),
        AutoRoute(
          page: mainShellRoute,
          initial: true,
          guards: [authGuard],
          children: [
            AutoRoute(page: HomeRoute.page, initial: true, children: [
              AutoRoute(page: VenuesRoute.page, initial: true),
              AutoRoute(page: OrdersRoute.page),
              AutoRoute(page: ProfileRoute.page),
            ]),
          ],
        ),
      ];
}
