import 'package:flutter/material.dart';

class RoundedAvatar extends StatelessWidget {
  final ImageProvider? image;

  const RoundedAvatar({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 96,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child:
            image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    image: image!,
                    loadingBuilder:
                        (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : Center(
                                  child: SizedBox(width: 32, height: 32, child: const CircularProgressIndicator()),
                                ),
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (frame == null) {
                        return Center(child: SizedBox(width: 32, height: 32, child: const CircularProgressIndicator()));
                      }
                      return child;
                    },
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                )
                : Icon(Icons.image_rounded, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
