import 'package:flutter/material.dart';

import '../theme.dart';

class Avatar extends StatelessWidget {
  final double size;
  final ImageProvider image;
  final bool showStatus;
  final Color borderColor;
  final bool online;

  const Avatar({
    super.key,
    required this.image,
    this.size = 40,
    this.showStatus = false,
    this.online = false,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: DesignTheme.brandGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: borderColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(backgroundImage: image, radius: size / 2),
              ),
            ),
          ),
        ),
        if (showStatus)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: online
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF9CA3AF),
                border: Border.all(color: borderColor, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
