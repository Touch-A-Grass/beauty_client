import 'package:auto_route/auto_route.dart';
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
    return AutoTabsRouter.pageView(
      physics: NeverScrollableScrollPhysics(),
      homeIndex: 0,
      builder:
          (context, child, pageController) => Scaffold(
            body: Stack(
              children: [
                MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(padding: MediaQuery.of(context).padding + EdgeInsets.only(bottom: 16 + bottomHeight)),
                  child: child,
                ),
                Positioned(
                  left: 16 + MediaQuery.of(context).padding.left,
                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                  right: 16 + MediaQuery.of(context).padding.right,
                  child: MeasureSize(
                    onChange:
                        (size) => setState(() {
                          bottomHeight = size.height;
                        }),
                    child: HomeNavigationBar(
                      items: [
                        HomeNavigationBarItem(icon: Icons.home_rounded),
                        HomeNavigationBarItem(icon: Icons.search_rounded),
                        HomeNavigationBarItem(icon: Icons.history_rounded),
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
