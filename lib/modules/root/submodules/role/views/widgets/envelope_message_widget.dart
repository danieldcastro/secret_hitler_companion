import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';

class EnvelopeMessageWidget extends StatelessWidget {
  final String playerName;
  final bool isBurned;
  const EnvelopeMessageWidget({
    required this.playerName,
    this.isBurned = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipPath(
    clipper: isBurned ? BurntEdgeClipper() : null,
    child: Container(
      height: 32,
      width: 65,
      color: AppColors.coral,
      child: Row(
        spacing: 3,
        children: [
          const SizedBox(width: 1),
          Icon(Icons.warning_rounded, size: 15, color: AppColors.black),
          Expanded(
            child: Text(
              context.loc.envelopeMessage(playerName),
              style: AppTextStyles.labelSmall().copyWith(fontSize: 4),
            ),
          ),
        ],
      ),
    ),
  );
}

class BurntEdgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final random = math.Random(42); // Seed fixo para consistência

    // Começa no canto superior esquerdo (com variação)
    path.moveTo(10, 5);

    // Borda superior (ondulada/queimada)
    _addBurntEdge(
      path,
      startX: 10,
      startY: 5,
      endX: size.width - 10,
      endY: 5,
      random: random,
      segments: 15,
    );

    // Canto superior direito
    path.lineTo(size.width - 5, 10);

    // Borda direita (ondulada/queimada)
    _addBurntEdge(
      path,
      startX: size.width - 5,
      startY: 10,
      endX: size.width - 5,
      endY: size.height - 10,
      random: random,
      segments: 20,
      isVertical: true,
    );

    // Canto inferior direito
    path.lineTo(size.width - 10, size.height - 5);

    // Borda inferior (ondulada/queimada)
    _addBurntEdge(
      path,
      startX: size.width - 10,
      startY: size.height - 5,
      endX: 10,
      endY: size.height - 5,
      random: random,
      segments: 15,
      reverse: true,
    );

    // Canto inferior esquerdo
    path.lineTo(5, size.height - 10);

    // Borda esquerda (ondulada/queimada)
    _addBurntEdge(
      path,
      startX: 5,
      startY: size.height - 10,
      endX: 5,
      endY: 10,
      random: random,
      segments: 20,
      isVertical: true,
      reverse: true,
    );

    path.close();
    return path;
  }

  void _addBurntEdge(
    Path path, {
    required double startX,
    required double startY,
    required double endX,
    required double endY,
    required math.Random random,
    required int segments,
    bool isVertical = false,
    bool reverse = false,
  }) {
    for (int i = 0; i < segments; i++) {
      final t = i / segments;
      final nextT = (i + 1) / segments;

      // Variação aleatória para simular queimadura
      final variation1 = (random.nextDouble() - 0.5) * 8;
      final variation2 = (random.nextDouble() - 0.5) * 8;

      double x1, y1, x2, y2;

      if (isVertical) {
        if (reverse) {
          y1 = endY + t * (startY - endY);
          y2 = endY + nextT * (startY - endY);
          x1 = startX + variation1;
          x2 = startX + variation2;
        } else {
          y1 = startY + t * (endY - startY);
          y2 = startY + nextT * (endY - startY);
          x1 = startX + variation1;
          x2 = startX + variation2;
        }
      } else {
        if (reverse) {
          x1 = endX + t * (startX - endX);
          x2 = endX + nextT * (startX - endX);
          y1 = startY + variation1;
          y2 = startY + variation2;
        } else {
          x1 = startX + t * (endX - startX);
          x2 = startX + nextT * (endX - startX);
          y1 = startY + variation1;
          y2 = startY + variation2;
        }
      }

      // Adiciona ponto de controle para curva suave
      final cpX = (x1 + x2) / 2 + (random.nextDouble() - 0.5) * 5;
      final cpY = (y1 + y2) / 2 + (random.nextDouble() - 0.5) * 5;

      path.quadraticBezierTo(cpX, cpY, x2, y2);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
