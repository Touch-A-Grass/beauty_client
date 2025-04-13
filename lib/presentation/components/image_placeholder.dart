import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      padding: EdgeInsets.all(16),
      child: Icon(Icons.image_rounded, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
