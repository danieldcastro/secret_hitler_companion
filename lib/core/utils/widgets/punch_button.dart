import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';

class PunchButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;
  final Widget child;
  final double height;
  final double width;
  const PunchButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.color = AppColors.black,
    this.shadowColor = AppColors.beige,
    this.height = 74,
    this.width = 250,
  });

  @override
  State<PunchButton> createState() => _PunchButtonState();
}

class _PunchButtonState extends State<PunchButton> {
  static const double _shadowHeight = _basePosition;
  static const double _basePosition = 10;
  double _position = _basePosition;

  Future<void> _playSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource(AudioPaths.button.substring(7)));
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height - _shadowHeight;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapUp: (_) async {
          setState(() => _position = _basePosition);
          await Future.delayed(
            const Duration(milliseconds: 100),
            () => widget.onPressed?.call(),
          );
        },
        onTapDown: (_) {
          _playSound();
          setState(() => _position = 0);
        },
        onTapCancel: () {
          setState(() => _position = _basePosition);
        },
        child: SizedBox(
          height: height + _shadowHeight,
          width: widget.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: widget.color.withAlpha(200),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeIn,
                bottom: _position,
                duration: Duration(milliseconds: 70),
                child: Container(
                  height: height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
