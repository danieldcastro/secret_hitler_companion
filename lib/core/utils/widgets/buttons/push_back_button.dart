import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/push_button/push_button.dart';

class PushBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PushBackButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => PushButton(
    borderRadius: BorderRadius.circular(10),
    width: 75,
    height: 45,
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        context.loc.backLabel.toUpperCase(),
        style: AppTextStyles.bodyMedium(
          color: AppColors.beige,
        ).copyWith(height: 1.7),
      ),
    ),
  );
}
