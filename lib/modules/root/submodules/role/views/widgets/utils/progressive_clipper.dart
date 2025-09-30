import 'dart:math';

import 'package:flutter/material.dart';

class ProgressiveClipper extends CustomClipper<Path> {
  const ProgressiveClipper({required this.revealWidth});

  final double revealWidth;

  @override
  Path getClip(Size size) {
    final maxWidth = revealWidth.clamp(0.0, size.width);
    final path = Path();
    if (maxWidth <= 0) return path;

    const flapBottomY = 1.0;
    final rng = Random(12345);
    final segments = (maxWidth / 5).ceil().clamp(1, 9999);
    final segmentWidth = maxWidth / segments;

    path
      ..moveTo(0, 0)
      ..lineTo(0, flapBottomY);

    for (int i = 0; i < segments; i++) {
      final currentX = (i + 1) * segmentWidth;
      final yVariation = (rng.nextDouble() - 0.5) * 2;
      final targetY = flapBottomY + yVariation;
      final controlX1 = currentX - segmentWidth * 0.5;
      final controlY1 = flapBottomY + (rng.nextDouble() - 0.5) * 8;
      path.quadraticBezierTo(controlX1, controlY1, currentX, targetY);
    }

    path
      ..lineTo(maxWidth, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant ProgressiveClipper oldClipper) =>
      oldClipper.revealWidth != revealWidth;
}
