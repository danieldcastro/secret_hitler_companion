import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/stamp_text.dart';

class BackEnvelopeWidget extends StatefulWidget {
  final String playerName;
  const BackEnvelopeWidget({required this.playerName, super.key});

  @override
  State<BackEnvelopeWidget> createState() => _BackEnvelopeWidgetState();
}

class _BackEnvelopeWidgetState extends State<BackEnvelopeWidget> {
  final stampAngle = Random().nextDouble() * -0.2;
  final stampScale = 0.8 + Random().nextDouble() * 0.3;
  final eyeXOffset = 10 + Random().nextInt(31);
  final eyeAngle = Random().nextDouble() * 0.5;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Image.asset(
        ImagePaths.backEnvelope,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
      Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: FittedBox(
              child: Text(
                widget.playerName,
                style:
                    AppTextStyles.headlineLarge(
                      fontFamily: FontFamilyEnum.body,
                    ).copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..color = Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          color: AppColors.black.withAlpha(100),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 8,
        right: 8,
        child: FittedBox(
          child: Transform.scale(
            scale: stampScale,
            child: StampText(
              text: context.loc.confidentialLabel.toUpperCase(),
              angle: stampAngle,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 22,
        left: 10,
        right: 8,
        child: FittedBox(
          child: Transform.scale(
            scale: stampScale * 0.9,
            child: StampText(
              text: context.loc.topSecretLabel.toUpperCase(),
              angle: -stampAngle,
            ),
          ),
        ),
      ),
      Positioned(
        top: 8,
        left: eyeXOffset.toDouble(),
        child: Transform.rotate(
          angle: eyeAngle,
          child: Icon(
            LucideIcons.eyeOff,
            color: AppColors.black.withAlpha(150),
            size: 20,
          ),
        ),
      ),
    ],
  );
}
