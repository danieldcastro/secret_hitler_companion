import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/mixins/vibrator_mixin.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/push_button/push_visual_button.dart';

class PushButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const PushButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.black,
    this.foregroundColor = AppColors.beige,
    this.height = 74,
    this.width = 250,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  State<PushButton> createState() => _PushButtonState();
}

class _PushButtonState extends State<PushButton>
    with AudioMixin, VibratorMixin {
  static const double _basePosition = 10;
  double _position = _basePosition;

  Future<void> _playButtonDownSound() async =>
      playAudio('buttonDown', AudioPaths.buttonDown);

  Future<void> _playButtonUpSound() async =>
      playAudio('buttonUp', AudioPaths.buttonUp);

  @override
  void dispose() {
    disposeAudios();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTapDown: (_) async {
        await _playButtonDownSound();
        if (mounted) setState(() => _position = 0);
      },
      onTapUp: (_) async {
        await _playButtonUpSound();
        if (mounted) setState(() => _position = _basePosition);
        widget.onPressed?.call();
      },
      onTapCancel: () {
        if (mounted) setState(() => _position = _basePosition);
      },
      child: PushVisualButton(
        height: widget.height,
        width: widget.width,
        position: _position,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        child: (_) => widget.child,
        borderRadius: widget.borderRadius,
      ),
    ),
  );
}
