import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

class EnvelopeWidget extends StatelessWidget {
  final String voterName;
  const EnvelopeWidget({required this.voterName, super.key});

  @override
  Widget build(BuildContext context) => Transform(
    alignment: Alignment.center,
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.004)
      ..rotateX(-0.6),
    child: LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Image.asset(ImagePaths.straightEnvelope),
          Positioned.fill(
            top: constraints.maxHeight * 0.05,
            left: constraints.maxWidth * 0.2,
            right: constraints.maxWidth * 0.2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: Text(
                voterName.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium(
                  fontFamily: FontFamilyEnum.body,
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: constraints.maxHeight * 0.4,
          //   left: constraints.maxWidth * 0.001,
          //   child: Transform.scale(
          //     scale: (constraints.maxWidth * 0.013) / 5,
          //     child: StampText(text: 'TOP SECRET', angle: -0.7),
          //   ),
          // ),
          // Positioned(
          //   bottom: 190,
          //   right: 10,
          //   child: StampText(
          //     text: 'CONFIDENCIAL',
          //     angle: -0.4,
          //     textStyle: AppTextStyles.bodyMedium(),
          //   ),
          // ),
        ],
      ),
    ),
  );
}
