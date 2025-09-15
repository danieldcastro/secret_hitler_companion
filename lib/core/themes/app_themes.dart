import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_input_decoration_theme.dart';
import 'package:secret_hitler_companion/core/themes/app_text_selection_theme.dart';
import 'package:secret_hitler_companion/core/themes/app_text_theme.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.beige,
    scaffoldBackgroundColor: AppColors.propRed,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.beige,
      foregroundColor: AppColors.propRed,
      elevation: 0,
    ),
    textTheme: AppTextTheme.light,
    inputDecorationTheme: AppInputDecorationTheme.light,
    textSelectionTheme: AppTextSelectionTheme.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.beige,
      secondary: AppColors.paper,
      surface: AppColors.propRed,
      error: AppColors.coral,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
    ),
  );
}
