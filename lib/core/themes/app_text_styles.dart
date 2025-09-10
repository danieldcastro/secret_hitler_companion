import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(
    double fontSize,
    FontWeight? fontWeight,
    Color? color,
  ) => TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? AppColors.black,
  );

  /// headline1: tamanho 96, peso light (w300)
  static TextStyle headline1({Color? color, FontWeight? fontWeight}) =>
      _base(96, fontWeight ?? FontWeight.w300, color);

  /// headline2: tamanho 60, peso light (w300)
  static TextStyle headline2({Color? color, FontWeight? fontWeight}) =>
      _base(60, fontWeight ?? FontWeight.w300, color);

  /// headline3: tamanho 48, peso normal
  static TextStyle headline3({Color? color, FontWeight? fontWeight}) =>
      _base(48, fontWeight ?? FontWeight.normal, color);

  /// headline4: tamanho 34, peso normal
  static TextStyle headline4({Color? color, FontWeight? fontWeight}) =>
      _base(34, fontWeight ?? FontWeight.normal, color);

  /// headline5: tamanho 24, peso normal
  static TextStyle headline5({Color? color, FontWeight? fontWeight}) =>
      _base(24, fontWeight ?? FontWeight.normal, color);

  /// headline6: tamanho 20, peso medium (w500)
  static TextStyle headline6({Color? color, FontWeight? fontWeight}) =>
      _base(20, fontWeight ?? FontWeight.w500, color);

  /// subtitle1: tamanho 16, peso normal
  static TextStyle subtitle1({Color? color, FontWeight? fontWeight}) =>
      _base(16, fontWeight ?? FontWeight.normal, color);

  /// subtitle2: tamanho 14, peso medium (w500)
  static TextStyle subtitle2({Color? color, FontWeight? fontWeight}) =>
      _base(14, fontWeight ?? FontWeight.w500, color);

  /// bodyText1: tamanho 16, peso normal
  static TextStyle bodyText1({Color? color, FontWeight? fontWeight}) =>
      _base(16, fontWeight ?? FontWeight.normal, color);

  /// bodyText2: tamanho 14, peso normal
  static TextStyle bodyText2({Color? color, FontWeight? fontWeight}) =>
      _base(14, fontWeight ?? FontWeight.normal, color);

  /// button: tamanho 14, peso medium (w500)
  static TextStyle button({Color? color, FontWeight? fontWeight}) =>
      _base(14, fontWeight ?? FontWeight.w500, color);

  /// caption: tamanho 12, peso normal
  static TextStyle caption({Color? color, FontWeight? fontWeight}) =>
      _base(12, fontWeight ?? FontWeight.normal, color);

  /// overline: tamanho 10, peso normal
  static TextStyle overline({Color? color, FontWeight? fontWeight}) =>
      _base(10, fontWeight ?? FontWeight.normal, color);
}
