import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class TableEdgeWidget extends StatelessWidget {
  const TableEdgeWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Divider(color: AppColors.lightPropRed, thickness: 3, height: 0),
      Divider(
        color: AppColors.lightPropRed.withAlpha(100),
        thickness: 10,
        height: 10,
      ),
      Divider(color: AppColors.black, thickness: 5, height: 5),
    ],
  );
}
