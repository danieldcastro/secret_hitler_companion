import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class TornFlapEdgePainter extends CustomPainter {
  const TornFlapEdgePainter({
    required this.progress,
    required this.topRegionFraction,
  });

  final double progress;
  final double topRegionFraction;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    const flapBottomY = 3.0;
    const leftPadding = 2.0;
    final maxWidth = size.width * progress;

    final paint = Paint()
      ..color = AppColors.black.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = AppColors.paper.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final highlightPaint = Paint()
      ..color = AppColors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final path = Path();
    final shadowPath = Path();
    final highlightPath = Path();

    final startX = maxWidth;
    if (startX <= 0) return;

    final segments = (startX / 4).ceil();
    if (segments <= 0) return;

    final segmentWidth = startX / segments;

    path.moveTo(leftPadding, flapBottomY);
    shadowPath.moveTo(leftPadding, flapBottomY + 0.3);
    highlightPath.moveTo(leftPadding, flapBottomY - 0.3);

    final rng = Random(12345);

    for (int i = 0; i < segments; i++) {
      final currentX = (i + 1) * segmentWidth;
      final yVariation = (rng.nextDouble() - 0.5) * 1.5;
      final targetY = flapBottomY + yVariation;
      final controlX1 = currentX - segmentWidth * 0.3;
      final controlY1 = flapBottomY + (rng.nextDouble() - 0.5) * 3;

      path.quadraticBezierTo(controlX1, controlY1, currentX, targetY);
      shadowPath.quadraticBezierTo(
        controlX1,
        controlY1 + 0.3,
        currentX,
        targetY + 0.3,
      );
      highlightPath.quadraticBezierTo(
        controlX1,
        controlY1 - 0.3,
        currentX,
        targetY - 0.3,
      );
    }

    if (progress > 0.05) {
      canvas
        ..drawPath(shadowPath, shadowPaint)
        ..drawPath(path, paint)
        ..drawPath(highlightPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TornFlapEdgePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.topRegionFraction != topRegionFraction;
}
