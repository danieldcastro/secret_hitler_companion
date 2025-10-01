import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/burned_edge_clipper.dart';

class EnvelopeMessageWidget extends StatelessWidget {
  final String playerName;
  final bool isBurned;
  const EnvelopeMessageWidget({
    required this.playerName,
    this.isBurned = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipPath(
    clipper: isBurned ? BurnedEdgeClipper() : null,
    child: Container(
      height: 32,
      width: 65,
      color: AppColors.coral,
      child: Row(
        spacing: 3,
        children: [
          const SizedBox(width: 1),
          Icon(Icons.warning_rounded, size: 15, color: AppColors.black),
          Expanded(
            child: Text(
              context.loc.envelopeMessage(playerName),
              style: AppTextStyles.labelSmall().copyWith(fontSize: 4),
            ),
          ),
        ],
      ),
    ),
  );
}
