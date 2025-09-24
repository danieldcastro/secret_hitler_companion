import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

class EnvelopeWidget extends StatelessWidget {
  final String voterName;
  const EnvelopeWidget({required this.voterName, super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      children: [
        Image.asset(ImagePaths.straightEnvelope),
        Stack(
          children: [
            Image.asset(ImagePaths.straightEnvelope),

            // texto por cima
            Positioned(
              top: constraints.maxHeight * 0.02, // mais perto do topo
              left: constraints.maxWidth * 0.1,
              right: constraints.maxWidth * 0.1,
              height: constraints.maxHeight * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    'AOS OLHOS DE',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall().copyWith(
                      fontSize: 2,
                      height: 1,
                    ),
                    maxLines: 1,
                    minFontSize: 1,
                  ),
                  Center(
                    child: AutoSizeText(
                      voterName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium(
                        fontFamily: FontFamilyEnum.body,
                      ).copyWith(fontSize: 5),
                      maxLines: 1,
                      minFontSize: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Se quiser manter os stamps depois é só descomentar
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
  );
}
