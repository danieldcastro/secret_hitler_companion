import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class LogoWidget extends StatelessWidget {
  final double fontSize;
  const LogoWidget({super.key, this.fontSize = 50});

  @override
  Widget build(BuildContext context) {
    final scale = fontSize / 150;

    return FittedBox(
      child: SizedBox(
        height: 400 * scale,
        child: Stack(
          children: [
            _buildCustomText('SECRET', scale, fontSize),
            Positioned(
              top: 120 * scale,
              left: 0,
              child: _buildCustomText('HITLER', scale, fontSize),
            ),
            Positioned(
              top: 260 * scale,
              left: 14,
              child: _buildCustomText('Companion', scale, 30),
            ),
          ],
        ),
      ),
    );
  }

  Transform _buildCustomText(
    String text,
    double scale,
    double fontSize, [
    Color? color,
  ]) {
    final textStyle = AppTextStyles.displayLarge(
      fontWeight: FontWeight.w900,
    ).copyWith(fontSize: fontSize);

    return Transform.rotate(
      angle: -0.15,
      child: SizedBox(
        height: 220 * scale,
        width: 500 * scale,
        child: Stack(
          children: [
            for (int i = 1; i < 60 * scale; i++)
              Positioned(
                left: i.toDouble(),
                top: i.toDouble(),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(color: color ?? AppColors.beige),
            ),
          ],
        ),
      ),
    );
  }
}
