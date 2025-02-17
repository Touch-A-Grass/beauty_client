import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          initial: true,
        ),
      ];
}
