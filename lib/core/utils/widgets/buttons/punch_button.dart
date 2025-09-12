import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';

class PunchButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget Function(bool isOverlay) child;
  final double height;
  final double width;

  const PunchButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.black,
    this.foregroundColor = AppColors.beige,
    this.height = 74,
    this.width = 250,
  });

  @override
  State<PunchButton> createState() => _PunchButtonState();
}

class _PunchButtonState extends State<PunchButton>
    with SingleTickerProviderStateMixin {
  static const double _shadowHeight = _basePosition;
  static const double _basePosition = 10;
  double _position = _basePosition;
  final _player = AudioPlayer();

  Timer? _holdTimer;
  double _progress = 0;
  static const _holdDuration = Duration(seconds: 2);

  late AnimationController _resetController;

  Future<void> _playButtonDownSound() async =>
      _player.play(AssetSource(AudioPaths.buttonDown.substring(7)));

  Future<void> _playButtonUpSound() async =>
      _player.play(AssetSource(AudioPaths.buttonUp.substring(7)));

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(_updateProgressListener);
  }

  void _updateProgressListener() {
    if (!mounted) return;
    setState(() => _progress = _resetController.value);
  }

  void _startHold() {
    if (!mounted) return;
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
        widget.onPressed?.call();
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _cancelHold();
          });
        }
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    if (!mounted) return; // evita crash se já desmontou
    _resetController.value = _progress;
    _resetController.reverse(from: _progress);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _player.dispose();
    _resetController
      ..removeListener(_updateProgressListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height - _shadowHeight;
    final borderRadius = BorderRadius.circular(4);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) {
          _playButtonDownSound();
          if (mounted) setState(() => _position = 0);
          _startHold();
        },
        onTapUp: (_) async {
          await _playButtonUpSound();
          if (mounted) setState(() => _position = _basePosition);
          if (_progress < 1) {
            _cancelHold();
          }
        },
        onTapCancel: () {
          if (mounted) setState(() => _position = _basePosition);
          _cancelHold();
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
                    color: widget.backgroundColor.withAlpha(200),
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeIn,
                bottom: _position,
                duration: const Duration(milliseconds: 70),
                child: Stack(
                  children: [
                    Container(
                      height: height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: borderRadius,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: borderRadius,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: _progress,
                        child: Container(
                          height: height,
                          width: widget.width,
                          color: widget.foregroundColor,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: borderRadius,
                      child: Transform.translate(
                        offset: Offset(0, height * (-_progress)),
                        child: SizedBox(
                          height: height,
                          width: widget.width,
                          child: Center(child: widget.child(false)),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: borderRadius,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: _progress.clamp(0.0, 1.0),
                        child: SizedBox(
                          height: height,
                          width: widget.width,
                          child: Center(child: widget.child(true)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
