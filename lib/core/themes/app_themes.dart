import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_theme.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.propRed,
    scaffoldBackgroundColor: AppColors.beige,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.propRed,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.propRed,
      foregroundColor: Colors.white,
    ),
    textTheme: AppTextTheme.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.propRed,
      secondary: AppColors.paper,
      surface: AppColors.beige,
      error: AppColors.coral,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
    ),
  );
}
