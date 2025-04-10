import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final ImageProvider? image;

  const Avatar({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 80,
      child: CircleAvatar(
        child:
            image != null
                ? Image(
                  image: image!,
                  loadingBuilder:
                      (context, child, loadingProgress) =>
                          loadingProgress == null ? child : const CircularProgressIndicator(),
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame == null) {
                      return const CircularProgressIndicator();
                    }
                    return child;
                  },
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                )
                : Icon(Icons.person),
      ),
    );
  }
}
