import 'package:flutter/material.dart';

class PushVisualButton extends StatelessWidget {
  final double height;
  final double width;
  final double position;
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget Function(bool isOverlay) child;
  final BorderRadius borderRadius;

  const PushVisualButton({
    required this.height,
    required this.width,
    required this.position,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.child,
    this.progress = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double realHeight = height - 10;

    return SizedBox(
      height: realHeight + 10,
      width: width,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: realHeight,
              width: width,
              decoration: BoxDecoration(
                color: backgroundColor.withAlpha(200),
                borderRadius: borderRadius,
              ),
            ),
          ),

          AnimatedPositioned(
            curve: Curves.easeIn,
            bottom: position,
            duration: const Duration(milliseconds: 70),
            child: Stack(
              children: [
                Container(
                  height: realHeight,
                  width: width,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  ),
                ),

                ClipRRect(
                  borderRadius: borderRadius,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: progress,
                    child: Container(
                      height: realHeight,
                      width: width,
                      color: foregroundColor,
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: borderRadius,
                  child: Transform.translate(
                    offset: Offset(0, realHeight * (-progress)),
                    child: SizedBox(
                      height: realHeight,
                      width: width,
                      child: Center(child: child(false)),
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: borderRadius,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: progress.clamp(0.0, 1.0),
                    child: SizedBox(
                      height: realHeight,
                      width: width,
                      child: Center(child: child(true)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
