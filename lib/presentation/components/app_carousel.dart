import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppCarouselController extends ChangeNotifier {
  AppCarouselController(int length) : _length = length;

  int _length = 0;

  int get length => _length;

  set length(int value) {
    if (value == _length) return;
    _length = value;
    notifyListeners();
  }

  int _page = 0;

  int get page => _page;

  set page(int value) {
    if (value == _page) return;
    _page = value % length;
    notifyListeners();
  }

  final ValueNotifier<double> _animation = ValueNotifier(0.0);

  ValueListenable<double> get animation => _animation;

  set animationValue(double value) {
    _animation.value = value;
  }

  void nextPage() {
    if (length == 0) return;
    page = (page + 1) % length;
  }

  void previousPage() {
    if (length == 0) return;
    page = (page - 1) % length;
  }
}

class AppCarousel extends StatefulWidget {
  static const pageSwitchDuration = Duration(seconds: 5);

  final AppCarouselController controller;
  final NullableIndexedWidgetBuilder itemBuilder;
  final bool enableScroll;

  const AppCarousel({super.key, required this.controller, required this.itemBuilder, this.enableScroll = true});

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> with TickerProviderStateMixin {
  late final AnimationController pageAnimationController;

  late final PageController pageController = PageController(initialPage: widget.controller.length * 100);

  double get pageControllerPage => (pageController.page ?? 0) % widget.controller.length;

  double prevPageAnimationValue = 0;

  bool manualScroll = false;

  bool listenPageAnimation = true;

  int prevLength = 0;

  Timer? _resumeTimer;

  @override
  void didUpdateWidget(covariant AppCarousel oldWidget) {
    if (oldWidget.enableScroll != widget.enableScroll) {
      _updatePageAnimationControllerState();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updatePageAnimationControllerState() {
    if (widget.enableScroll && !manualScroll) {
      pageAnimationController.repeat();
      listenPageAnimation = true;
    } else {
      listenPageAnimation = false;
      pageAnimationController.animateBack(0, duration: Duration(milliseconds: 250));
      prevPageAnimationValue = 0;
    }
  }

  void _listenPageController() {
    widget.controller.animationValue = pageControllerPage;
    if (manualScroll && pageController.page != null) {
      widget.controller.page = pageControllerPage.round();
    }
  }

  void _listenCarouselController() {
    if (manualScroll) return;
    if (widget.controller.page != pageControllerPage) {
      pageController.animateToPage(
        ((pageController.page! + 1).round() / widget.controller.length).floor() * widget.controller.length +
            widget.controller.page,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _listenPageAnimation() {
    if (manualScroll) return;
    void updateControllerAnimation() {
      widget.controller.animationValue = pageAnimationController.value + widget.controller.page;
    }

    if (!listenPageAnimation) {
      updateControllerAnimation();
      return;
    }
    if (prevPageAnimationValue > pageAnimationController.value) {
      widget.controller.nextPage();
    }
    updateControllerAnimation();
    prevPageAnimationValue = pageAnimationController.value;
  }

  @override
  void initState() {
    pageAnimationController = AnimationController(vsync: this, duration: AppCarousel.pageSwitchDuration);

    pageAnimationController.addListener(_listenPageAnimation);
    widget.controller.addListener(_listenCarouselController);
    pageController.addListener(_listenPageController);

    _updatePageAnimationControllerState();

    super.initState();
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();

    widget.controller.removeListener(_listenCarouselController);
    pageController.removeListener(_listenPageController);
    pageAnimationController.removeListener(_listenPageAnimation);

    pageController.dispose();
    pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        if (widget.controller.length == 0) {
          return const SizedBox();
        }
        return Listener(
          onPointerMove: (e) {
            _resumeTimer?.cancel();
            manualScroll = true;
            pageAnimationController.stop();
            _listenPageController();
          },
          onPointerUp: (e) {
            _resumeTimer?.cancel();
            _resumeTimer = Timer(AppCarousel.pageSwitchDuration, () {
              manualScroll = false;
              prevPageAnimationValue = 0;
              pageAnimationController.value = 0;
              _updatePageAnimationControllerState();
            });
          },
          child: PageView.builder(
            physics:
                widget.controller.length == 1 || !widget.enableScroll
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
            controller: pageController,
            itemBuilder: (context, index) => widget.itemBuilder(context, index % widget.controller.length),
          ),
        );
      },
    );
  }
}
