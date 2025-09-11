import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontFamilyEnum fontFamily,
  ) => TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? AppColors.black,
    fontFamily: fontFamily.value,
  );

  // === Display ===
  /// displayLarge: tamanho 64
  static TextStyle displayLarge({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(64, fontWeight, color, fontFamily);

  /// displayMedium: tamanho 48
  static TextStyle displayMedium({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(48, fontWeight, color, fontFamily);

  /// displaySmall: tamanho 36
  static TextStyle displaySmall({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(36, fontWeight, color, fontFamily);

  // === Headline ===
  /// headlineLarge: tamanho 32
  static TextStyle headlineLarge({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(32, fontWeight, color, fontFamily);

  /// headlineMedium: tamanho 28
  static TextStyle headlineMedium({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(28, fontWeight, color, fontFamily);

  /// headlineSmall: tamanho 24
  static TextStyle headlineSmall({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.display,
    FontWeight? fontWeight,
  }) => _base(24, fontWeight, color, fontFamily);

  // === Title ===
  /// titleLarge: tamanho 20
  static TextStyle titleLarge({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(20, fontWeight, color, fontFamily);

  /// titleMedium: tamanho 18
  static TextStyle titleMedium({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(18, fontWeight, color, fontFamily);

  /// titleSmall: tamanho 16
  static TextStyle titleSmall({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(16, fontWeight, color, fontFamily);

  // === Body ===
  /// bodyLarge: tamanho 15
  static TextStyle bodyLarge({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(15, fontWeight, color, fontFamily);

  /// bodyMedium: tamanho 14
  static TextStyle bodyMedium({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(14, fontWeight, color, fontFamily);

  /// bodySmall: tamanho 12
  static TextStyle bodySmall({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(12, fontWeight, color, fontFamily);

  // === Label ===
  /// labelLarge: tamanho 11
  static TextStyle labelLarge({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(11, fontWeight, color, fontFamily);

  /// labelMedium: tamanho 10
  static TextStyle labelMedium({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(10, fontWeight, color, fontFamily);

  /// labelSmall: tamanho 9
  static TextStyle labelSmall({
    Color? color,
    FontFamilyEnum fontFamily = FontFamilyEnum.body,
    FontWeight? fontWeight,
  }) => _base(9, fontWeight, color, fontFamily);
}
