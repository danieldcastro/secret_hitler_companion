import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/lottie_paths.dart';

class RolePageMatchWidget extends StatelessWidget {
  final bool visible;

  const RolePageMatchWidget({required this.visible, super.key});

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: const Duration(milliseconds: 400),
    opacity: visible ? 1 : 0,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -25,
          left: -16,
          child: Lottie.asset(LottiePaths.fire, height: 35),
        ),
        Image.asset(ImagePaths.match, height: 40),
      ],
    ),
  );
}
