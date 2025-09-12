import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/punch_button.dart';

class SkullButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SkullButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => PunchButton(
    height: 100,
    width: 100,
    onPressed: onPressed,
    child: (hasPunch) => Padding(
      padding: const EdgeInsets.all(10),
      child: hasPunch
          ? Image.asset(ImagePaths.mustacheSkull, color: AppColors.black)
          : Image.asset(ImagePaths.skull, color: AppColors.beige),
    ),
  );
}
