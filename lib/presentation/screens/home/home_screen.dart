import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: AutoTabsRouter(
        builder: (context, child) => Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AutoTabsRouter.of(context).activeIndex,
            onTap: (index) {
              AutoTabsRouter.of(context).setActiveIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.house), label: 'Салоны'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Заказы'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
            ],
          ),
        ),
      ),
    );
  }
}
