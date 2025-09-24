import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get light => TextTheme(
    displayLarge: AppTextStyles.displayLarge(),
    displayMedium: AppTextStyles.displayMedium(),
    displaySmall: AppTextStyles.displaySmall(),
    headlineLarge: AppTextStyles.headlineLarge(),
    headlineMedium: AppTextStyles.headlineMedium(),
    headlineSmall: AppTextStyles.headlineSmall(),
    titleLarge: AppTextStyles.titleLarge(),
    titleMedium: AppTextStyles.titleMedium(),
    titleSmall: AppTextStyles.titleSmall(),
    bodyLarge: AppTextStyles.bodyLarge(),
    bodyMedium: AppTextStyles.bodyMedium(),
    bodySmall: AppTextStyles.bodySmall(),
    labelLarge: AppTextStyles.labelLarge(),
    labelMedium: AppTextStyles.labelMedium(),
    labelSmall: AppTextStyles.labelSmall(),
  );
}
