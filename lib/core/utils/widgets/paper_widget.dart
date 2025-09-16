import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

class PaperWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double height;
  final EdgeInsetsGeometry contentPadding;
  const PaperWidget({
    required this.title,
    this.width,
    this.height = 140,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 40),
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 140,
    width: width ?? double.infinity,
    constraints: BoxConstraints(maxWidth: 500),
    decoration: BoxDecoration(
      image: const DecorationImage(
        colorFilter: ColorFilter.mode(AppColors.paper, BlendMode.srcIn),
        image: AssetImage(ImagePaths.paper),
        fit: BoxFit.fill,
      ),
    ),
    child: Center(
      child: Padding(
        padding: contentPadding,
        child: Text(
          title,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleMedium(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}
