import 'package:flutter/material.dart';

class UnreadBadgeContainer extends StatelessWidget {
  final int count;
  final Widget child;

  const UnreadBadgeContainer({super.key, required this.count, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: -8,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: Text(
                count.toString(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
