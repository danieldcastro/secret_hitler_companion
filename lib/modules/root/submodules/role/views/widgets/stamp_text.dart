import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class StampText extends StatelessWidget {
  final String text;
  final double angle;
  final TextStyle? textStyle;
  const StampText({
    required this.text,
    this.angle = 0,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: angle,
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightPropRed, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: (textStyle ?? AppTextStyles.titleMedium()).copyWith(
          height: 1,
          fontFamily: 'Arial',
          color: AppColors.lightPropRed,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
