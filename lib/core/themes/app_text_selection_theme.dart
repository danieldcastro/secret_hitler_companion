import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class AppTextSelectionTheme {
  AppTextSelectionTheme._();

  static TextSelectionThemeData get light =>
      TextSelectionThemeData(cursorColor: AppColors.black);
}
