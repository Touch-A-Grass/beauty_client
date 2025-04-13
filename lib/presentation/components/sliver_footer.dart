import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum SliverFooterSlot { footer, sliver }

class SliverFooter extends SlottedMultiChildRenderObjectWidget<SliverFooterSlot, RenderObject> {
  final Widget footer;
  final Widget sliver;
  final bool fillRemaining;

  const SliverFooter({super.key, required this.footer, required this.sliver, this.fillRemaining = false});

  @override
  Widget? childForSlot(slot) => switch (slot) {
    SliverFooterSlot.footer => footer,
    SliverFooterSlot.sliver => sliver,
  };

  @override
  SlottedContainerRenderObjectMixin<SliverFooterSlot, RenderObject> createRenderObject(BuildContext context) {
    return SliverFooterRenderObject()..fillRemaining = fillRemaining;
  }

  @override
  void updateRenderObject(BuildContext context, covariant SliverFooterRenderObject renderObject) {
    renderObject.fillRemaining = fillRemaining;
  }

  @override
  Iterable<SliverFooterSlot> get slots => SliverFooterSlot.values;
}

class SliverFooterRenderObject extends RenderSliver
    with RenderSliverHelpers, SlottedContainerRenderObjectMixin<SliverFooterSlot, RenderObject> {
  bool _fillRemaining = false;

  bool get fillRemaining => _fillRemaining;

  set fillRemaining(bool value) {
    if (_fillRemaining != value) {
      _fillRemaining = value;
      markNeedsLayout();
    }
  }

  RenderSliver get sliver => childForSlot(SliverFooterSlot.sliver)! as RenderSliver;

  RenderBox get footer => childForSlot(SliverFooterSlot.footer)! as RenderBox;

  double get footerPosition =>
      fillRemaining
          ? constraints.viewportMainAxisExtent - footer.size.height
          : (constraints.remainingPaintExtent - footer.size.height).clamp(
            0.0,
            sliver.geometry!.scrollExtent - constraints.scrollOffset,
          );

  @override
  void performLayout() {
    sliver.layout(constraints, parentUsesSize: true);
    footer.layout(constraints.asBoxConstraints().tighten(width: constraints.crossAxisExtent), parentUsesSize: true);

    final childHeight = sliver.geometry!.scrollExtent + footer.size.height;

    final double extent = fillRemaining ? max(constraints.viewportMainAxisExtent, childHeight) : childHeight;

    final paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: extent);
    final cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: extent);

    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
      cacheExtent: cacheExtent,
    );
  }

  @override
  double childMainAxisPosition(covariant RenderObject child) {
    if (child == sliver) {
      return 0.0;
    }
    if (child == footer) {
      return footerPosition;
    }
    return 0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(sliver, offset);
    context.paintChild(footer, offset + Offset(0, footerPosition));
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    applyPaintTransformForBoxChild(footer, transform);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result, {double? mainAxisPosition, double? crossAxisPosition}) {
    if (mainAxisPosition == null || crossAxisPosition == null) {
      return false;
    }
    return hitTestBoxChild(
          BoxHitTestResult.wrap(result),
          footer,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ) ||
        sliver.hitTest(result, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition);
  }
}
