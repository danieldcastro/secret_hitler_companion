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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightPropRed, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: (textStyle ?? AppTextStyles.labelSmall()).copyWith(
          height: 1,
          fontFamily: 'Arial',
          color: AppColors.lightPropRed,
          fontWeight: FontWeight.w700,
          fontSize: 7,
        ),
      ),
    ),
  );
}
