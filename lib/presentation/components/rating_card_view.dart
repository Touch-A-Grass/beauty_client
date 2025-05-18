import 'package:flutter/material.dart';

class RatingCardView extends StatelessWidget {
  final double rating;
  final Color backgroundColor;
  final Color textColor;

  const RatingCardView({super.key, required this.rating, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            (rating / 2).toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          Icon(Icons.star_rounded, color: Colors.orange, size: 16),
        ],
      ),
    );
  }
}

class RatingStarView extends StatelessWidget {
  final double rating;

  const RatingStarView({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => Icon(Icons.star_rounded, color: Colors.grey, size: 20)),
        ),
        ClipRect(
          clipper: _StarClipper(rating: rating),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Icon(Icons.star_rounded, color: Colors.orange, size: 20)),
          ),
        ),
      ],
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double rating;

  _StarClipper({required this.rating});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * (rating / 10), size.height);

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.rating != rating;
  }
}
