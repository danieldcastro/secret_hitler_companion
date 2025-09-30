import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/lottie_paths.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_message_widget.dart';

class BurnedEnvelopeWidget extends StatelessWidget {
  final String playerName;
  const BurnedEnvelopeWidget({required this.playerName, super.key});

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned.fill(top: -100, child: Lottie.asset(LottiePaths.smoke)),
      Image.asset(
        ImagePaths.burnedEnvelope,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
      Positioned(
        left: 9,
        right: 8,
        top: 50,
        child: EnvelopeMessageWidget(playerName: playerName, isBurned: true),
      ),
    ],
  );
}
