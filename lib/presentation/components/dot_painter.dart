import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DotProgressWidget extends StatefulWidget {
  final Color color;
  final Color selectedColor;
  final ValueListenable<double> switchAnimation;
  final int position;
  final int length;

  const DotProgressWidget({
    super.key,
    required this.color,
    required this.switchAnimation,
    required this.position,
    required this.selectedColor,
    required this.length,
  });

  @override
  State<DotProgressWidget> createState() => _DotProgressWidgetState();
}

class _DotProgressWidgetState extends State<DotProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.switchAnimation]),
      builder: (context, child) {
        final value = widget.switchAnimation.value - widget.switchAnimation.value.floor();
        return CustomPaint(
          painter: DotProgressPainter(
            color: widget.color,
            switchStartProgress: (2 * value).clamp(0, 1),
            switchEndProgress: (2 * value - 1).clamp(0, 1),
            position: widget.switchAnimation.value.floor(),
            selectedColor: widget.selectedColor,
            length: widget.length,
          ),
          child: SizedBox(
            width:
                (widget.length - 1) * (DotProgressPainter.dotGap + DotProgressPainter.dotSize) +
                DotProgressPainter.dotSize,
            height: DotProgressPainter.dotSize,
          ),
        );
      },
    );
  }
}

class DotProgressPainter extends CustomPainter {
  final Color color;
  final Color selectedColor;
  final double switchStartProgress;
  final double switchEndProgress;
  final int position;
  final int length;

  DotProgressPainter({
    super.repaint,
    required this.color,
    required this.switchStartProgress,
    required this.switchEndProgress,
    required this.position,
    required this.selectedColor,
    required this.length,
  });

  static const dotSize = 8.0;
  static const dotGap = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 4
          ..style = PaintingStyle.fill;

    final selectedPaint =
        Paint()
          ..color = selectedColor
          ..style = PaintingStyle.fill;

    final previousPaint =
        Paint()
          ..color = Color.lerp(selectedColor, color, switchStartProgress)!
          ..style = PaintingStyle.fill;

    final nextPaint =
        Paint()
          ..color = Color.lerp(color, selectedColor, switchEndProgress)!
          ..style = PaintingStyle.fill;

    for (int i = 0; i < length; i++) {
      canvas.drawCircle(
        Offset(i * dotGap, dotSize / 2),
        dotSize / 2,
        i == position % length
            ? previousPaint
            : i == (position + 1) % length
            ? nextPaint
            : paint,
      );
    }

    if (position < length - 1) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          position * dotGap + switchEndProgress * dotGap - dotSize / 2,
          0,
          position * dotGap + switchStartProgress * dotGap + dotSize / 2,
          dotSize,
          const Radius.circular(dotSize * 2),
        ),
        selectedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
