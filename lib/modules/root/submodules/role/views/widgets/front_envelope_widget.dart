import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/burned_envelope_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_message_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/progressive_clipper.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/torn_flap_edge_painter.dart';

class FrontEnvelopeWidget extends StatelessWidget {
  final double progress;
  final double topRegionFraction;
  final double revealWidth;
  final BoxConstraints constraints;
  final String playerName;
  final double revealOffset;
  final bool isTornComplete;
  final bool isBurned;
  const FrontEnvelopeWidget({
    required this.progress,
    required this.topRegionFraction,
    required this.revealWidth,
    required this.constraints,
    required this.playerName,
    required this.revealOffset,
    required this.isTornComplete,
    required this.isBurned,
    super.key,
  });

  @override
  Widget build(BuildContext context) => isBurned
      ? BurnedEnvelopeWidget(playerName: playerName)
      : Stack(
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: Offset(
                0.05,
                isTornComplete
                    ? revealOffset == 0
                          ? -0.01
                          : revealOffset / 100
                    : 0.2,
              ),
              curve: Curves.elasticOut,
              child: Container(
                color: Colors.amber,
                width: constraints.maxWidth - 7,
                height: constraints.maxHeight / 2,
              ),
            ),
            Image.asset(
              ImagePaths.straightEnvelope,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
            if (progress == 1)
              Image.asset(
                ImagePaths.tornEnvelope,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            if (progress > 0.1)
              ClipPath(
                clipper: ProgressiveClipper(revealWidth: revealWidth),
                child: Image.asset(
                  ImagePaths.tornEnvelope,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            Positioned(
              left: 2.2,
              right: 2,
              top: 50,
              child: EnvelopeMessageWidget(playerName: playerName),
            ),
            if (progress > 0.1 && progress < 0.99)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: TornFlapEdgePainter(
                  progress: progress,
                  topRegionFraction: topRegionFraction,
                ),
              ),
          ],
        );
}
