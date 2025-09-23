import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/audio_key_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/mixins/vibrator_mixin.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/push_button/push_visual_button.dart';

@override
class HoldButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget Function(bool isOverlay) child;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const HoldButton({
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
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin, AudioMixin, VibratorMixin {
  static const double _basePosition = 10;
  double _position = _basePosition;
  double _progress = 0;

  Timer? _holdTimer;
  late AnimationController _resetController;

  static const _holdDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      await createPool(AudioKeyEnum.buttonDown, AudioPaths.buttonDown);
      await createPool(AudioKeyEnum.buttonUp, AudioPaths.buttonUp);
      await createPool(AudioKeyEnum.scrolling, AudioPaths.scrolling);
      await createPool(AudioKeyEnum.pushing, AudioPaths.pushing);
    });
    _resetController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        )..addListener(() {
          if (!mounted) return;
          setState(() => _progress = _resetController.value);
        });
  }

  Future<void> _playButtonDownSound() async =>
      playPooledAudio(AudioKeyEnum.buttonDown);
  Future<void> _playButtonUpSound() async =>
      playPooledAudio(AudioKeyEnum.buttonUp);
  Future<void> _playScrollingSound() async =>
      playPooledAudio(AudioKeyEnum.scrolling);
  Future<void> _playPushingSound() async =>
      playPooledAudio(AudioKeyEnum.pushing);
  Future<void> _stopScrollingSound() async =>
      stopPooledAudio(AudioKeyEnum.scrolling);

  Future<void> _vibrateScrolling() async => vibrate(1000);
  Future<void> _vibrateLong() async => vibrate(300);
  Future<void> _cancelVibration() async => cancelVibration();

  void _startHold() {
    _resetController.stop();
    _progress = 0;
    const tick = Duration(milliseconds: 30);
    int elapsed = 0;

    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(tick, (timer) async {
      elapsed += tick.inMilliseconds;
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _progress = (elapsed / _holdDuration.inMilliseconds).clamp(0.0, 1.0);
      });

      if (_progress >= 1) {
        timer.cancel();
        await _stopScrollingSound();
        await _playPushingSound();
        await _vibrateLong();
        await Future.delayed(
          const Duration(milliseconds: 500),
          widget.onPressed?.call,
        );
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), _cancelHold);
        }
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    _cancelVibration();
    _stopScrollingSound();
    if (!mounted) return;
    _resetController.value = _progress;
    _resetController.reverse(from: _progress);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    disposeAudios();
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTapDown: (_) async {
        await _playButtonDownSound();
        await _playScrollingSound();
        await _vibrateScrolling();
        if (mounted) setState(() => _position = 0);
        _startHold();
      },
      onTapUp: (_) async {
        await _playButtonUpSound();
        if (mounted) setState(() => _position = _basePosition);
        if (_progress < 1) _cancelHold();
      },
      onTapCancel: () {
        if (mounted) setState(() => _position = _basePosition);
        _cancelHold();
      },
      child: PushVisualButton(
        height: widget.height,
        width: widget.width,
        position: _position,
        progress: _progress,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        child: widget.child,
        borderRadius: widget.borderRadius,
      ),
    ),
  );
}
