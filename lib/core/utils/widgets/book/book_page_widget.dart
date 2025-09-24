import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class BookPageWidget extends StatelessWidget {
  final Widget child;
  const BookPageWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(2),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withAlpha(30),
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
      ],
    ),
    height: 80,
    width: 150,
    child: child,
  );
}
