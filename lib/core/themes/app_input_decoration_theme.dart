import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  static InputBorder get _border => UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.black.withAlpha(100)),
  );

  static InputDecorationTheme get light => InputDecorationTheme(
    border: _border,
    enabledBorder: _border,
    focusedBorder: _border,
    errorBorder: _border,
    focusedErrorBorder: _border,
    contentPadding: EdgeInsets.zero,
    labelStyle: AppTextStyles.displayLarge(color: AppColors.black),
    isDense: true,
    hintStyle: AppTextStyles.titleLarge(color: AppColors.black.withAlpha(150)),
    counterStyle: TextStyle(fontSize: 0),
    visualDensity: VisualDensity.compact,
  );
}
