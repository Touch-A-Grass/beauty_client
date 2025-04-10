import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/components/measure_size.dart';
import 'package:beauty_client/presentation/screens/home/components/home_navigation_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double bottomHeight = 0;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      builder:
          (context, child) => Scaffold(
            body: Stack(
              children: [
                MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(padding: MediaQuery.of(context).padding + EdgeInsets.only(bottom: 16 + bottomHeight)),
                  child: child,
                ),
                Positioned(
                  left: 16,
                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                  right: 16,
                  child: MeasureSize(
                    onChange:
                        (size) => setState(() {
                          bottomHeight = size.height;
                        }),
                    child: HomeNavigationBar(
                      items: [
                        HomeNavigationBarItem(icon: Icons.home),
                        HomeNavigationBarItem(icon: Icons.search),
                        HomeNavigationBarItem(icon: Icons.receipt),
                      ],
                      currentIndex: context.tabsRouter.activeIndex,
                      onItemTapped: (index) => context.tabsRouter.setActiveIndex(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
