import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SmoothScroll extends StatelessWidget {
  final ScrollController controller;
  final Widget child;
  final double scrollSpeed;
  final Duration scrollAnimationLength;
  final Curve curve;

  const SmoothScroll({
    super.key,
    required this.child,
    required this.controller,
    this.scrollSpeed = 2.5,
    this.scrollAnimationLength = const Duration(milliseconds: 1500),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _SmoothScroll(
        controller: controller,
        scrollSpeed: scrollSpeed,
        scrollAnimationLength: scrollAnimationLength,
        curve: curve,
        child: child,
      );
    }
    return child;
  }
}

class _SmoothScroll extends StatefulWidget {
  /// Scroll Controller for controlling the scroll behaviour manually
  /// so we can animate to next scrolled position and avoid the jerky movement
  /// of default scroll
  final ScrollController controller;

  /// Child scrollable widget.
  final Widget child;

  /// Scroll speed for adjusting the smoothness and add a bit of extra scroll
  /// Default value is 2.5
  /// You can try it for a range of 2 - 5
  final double scrollSpeed;

  /// Duration/length for how long the animation should go
  /// after the scroll has happened
  /// Default value is 1500ms
  final Duration scrollAnimationLength;

  /// Curve of the animation.
  final Curve curve;

  const _SmoothScroll({
    required this.controller,
    required this.child,
    this.scrollSpeed = 2.5,
    this.scrollAnimationLength = const Duration(milliseconds: 1500),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<_SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<_SmoothScroll> {
  // data variables
  double _scroll = 0;
  bool _isAnimating = false;
  double _targetScroll = 0;
  DateTime _lastScrollTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Adding listener so if value of listener is changed outside our class
    // it gets updated here to avoid unwanted scrolling behavior
    widget.controller.addListener(scrollListener);
    _targetScroll = widget.controller.initialScrollOffset;
  }

  @override
  void didUpdateWidget(covariant _SmoothScroll oldWidget) {
    if (!widget.controller.hasClients) {
      widget.controller.addListener(scrollListener);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(onPointerSignal: onPointerSignal, child: widget.child);
  }

  /// Member Functions
  ///
  ///
  void _smoothScrollTo(double delta) {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastScrollTime).inMilliseconds;
    _lastScrollTime = now;

    // Update target scroll position
    _targetScroll += (delta * widget.scrollSpeed);

    // Bound the scroll value
    if (_targetScroll > widget.controller.position.maxScrollExtent) {
      _targetScroll = widget.controller.position.maxScrollExtent;
    }
    if (_targetScroll < 0) {
      _targetScroll = 0;
    }

    // Calculate animation duration based on time between scrolls
    int animationDuration =
        timeDiff < 50
            ? widget.scrollAnimationLength.inMilliseconds ~/
                4 // Faster for rapid scrolling
            : widget.scrollAnimationLength.inMilliseconds;

    // If at bounds, use shorter animation
    if (_targetScroll == widget.controller.position.maxScrollExtent || _targetScroll == 0) {
      animationDuration = widget.scrollAnimationLength.inMilliseconds ~/ 4;
    }

    // Always start a new animation to the target
    widget.controller
        .animateTo(_targetScroll, duration: Duration(milliseconds: animationDuration), curve: widget.curve)
        .then((_) {
          setState(() => _isAnimating = false);
        });

    setState(() => _isAnimating = true);
  }

  void scrollListener() {
    _scroll = widget.controller.offset;
    // Update target scroll when user manually scrolls
    if (!_isAnimating) {
      _targetScroll = _scroll;
    }
  }

  void onPointerSignal(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      if (pointerSignal.kind != PointerDeviceKind.trackpad) {
        // Apply smooth scrolling for mouse wheel
        _smoothScrollTo(pointerSignal.scrollDelta.dy);
      } else {
        // For trackpad, calculate new offset with bounds checking
        final newOffset = (widget.controller.offset + pointerSignal.scrollDelta.dy).clamp(
          0.0,
          widget.controller.position.maxScrollExtent,
        );
        // Directly update scroll position without smoothing
        widget.controller.jumpTo(newOffset);
      }
    }
  }
}
