import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/audio_key_enum.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/mixins/vibrator_mixin.dart';

class DiscWidget extends StatefulWidget {
  final double dimension;
  final List<int> numbers;
  final ValueChanged<int> onNumberSelected;
  final int initialNumber;

  const DiscWidget({
    required this.numbers,
    required this.onNumberSelected,
    required this.initialNumber,
    super.key,
    this.dimension = 310,
  });

  @override
  State<DiscWidget> createState() => _DiscWidgetState();
}

class _DiscWidgetState extends State<DiscWidget>
    with SingleTickerProviderStateMixin, VibratorMixin, AudioMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  DateTime? lastVibrationTime;

  double _currentAngle = 0;
  double? _lastAngle;
  int? _currentNumber;
  int? _numberAfterDrag;
  bool _isDragging = false;
  bool _isPlayingUpSound = false;

  double? _startHoleAngle;
  final double _fingerStopAngle = 0.48; // fixed stop position

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _rotation = AlwaysStoppedAnimation(0);
    _numberAfterDrag = widget.initialNumber;
    scheduleMicrotask(() async {
      await createPool(AudioKeyEnum.dialUp, AudioPaths.phoneDialUp);
      await createPool(AudioKeyEnum.dialDown, AudioPaths.phoneDialDown);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    disposeAudios();
    super.dispose();
  }

  Future<void> _playDialUpSound() async => playPooledAudio(AudioKeyEnum.dialUp);

  Future<void> _playDialDownSound() async =>
      playPooledAudio(AudioKeyEnum.dialDown);

  Future<void> _playDialScrollingSound() async => playAudio(
    AudioKeyEnum.scroll,
    AudioPaths.phoneDialScrolling,
    volume: 0.5,
  );

  double _calculateAngle(Offset position, Offset center) {
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    return atan2(dy, dx);
  }

  double _normalizeAngleDifference(double angleDiff) {
    if (angleDiff > pi) return angleDiff - 2 * pi;
    if (angleDiff < -pi) return angleDiff + 2 * pi;
    return angleDiff;
  }

  double _getHoleAngle(int number) {
    final index = widget.numbers.indexOf(number);
    return -pi / 0.63 + index * (pi / (widget.numbers.length - 1.5));
  }

  double _calculateMaxAngleForNumber() {
    if (_startHoleAngle == null) return pi / 2;

    double diff = _fingerStopAngle - _startHoleAngle!;
    if (diff < 0) diff += 2 * pi;
    return diff;
  }

  int? _detectNumberFromTouch(Offset touch) {
    final center = Offset(widget.dimension / 2, widget.dimension / 2);
    final dx = touch.dx - center.dx;
    final dy = touch.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance < 80 || distance > 140) return null;

    final angle = atan2(dy, dx);
    int? closestNumber;
    double smallestDiff = double.infinity;

    for (final number in widget.numbers) {
      final ang = _getHoleAngle(number);
      final diff = _normalizeAngleDifference(angle - ang).abs();

      if (diff < smallestDiff) {
        smallestDiff = diff;
        closestNumber = number;
      }
    }

    if (smallestDiff > 0.4) return null;
    return closestNumber;
  }

  void _animateBack(double fromAngle) {
    _rotation = Tween<double>(
      begin: fromAngle,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller
      ..reset()
      ..forward()
      ..addListener(() {
        if (mounted) {
          setState(() {
            _currentAngle = _rotation.value;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      // sombra
      Positioned(
        bottom: -6,
        right: -5,
        child: Container(
          width: widget.dimension,
          height: widget.dimension,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.black.withAlpha(100),
          ),
        ),
      ),
      GestureDetector(
        onPanStart: (details) {
          _controller.stop();
          _playDialDownSound();
          vibrate(100);
          final center = Offset(widget.dimension / 2, widget.dimension / 2);
          _lastAngle = _calculateAngle(details.localPosition, center);

          final detectedNumber = _detectNumberFromTouch(details.localPosition);
          if (detectedNumber != null) {
            setState(() {
              _currentNumber = detectedNumber;
              _isDragging = true;
              _startHoleAngle = _getHoleAngle(detectedNumber);
            });
          }
        },
        onPanUpdate: (details) {
          if (!_isDragging) return;
          final center = Offset(widget.dimension / 2, widget.dimension / 2);
          final currentTouchAngle = _calculateAngle(
            details.localPosition,
            center,
          );

          if (_lastAngle != null) {
            double angleDiff = currentTouchAngle - _lastAngle!;
            angleDiff = _normalizeAngleDifference(angleDiff);

            final now = DateTime.now();
            if (lastVibrationTime == null ||
                now.difference(lastVibrationTime ?? DateTime.now()) >
                    const Duration(milliseconds: 50)) {
              vibrate(100);
              lastVibrationTime = now;
            }
            setState(() {
              final double maxAngleForNumber = _calculateMaxAngleForNumber();
              final double newAngle = _currentAngle + angleDiff;
              _currentAngle = newAngle.clamp(0, maxAngleForNumber);
              _rotation = AlwaysStoppedAnimation(_currentAngle);
            });
          }

          if (_currentAngle >= (_calculateMaxAngleForNumber() * 0.95) &&
              !_isPlayingUpSound) {
            _playDialUpSound();

            _isPlayingUpSound = true;
          }

          _lastAngle = currentTouchAngle;
        },
        onPanEnd: (_) async {
          if (!_isDragging) return;

          _lastAngle = null;
          _isDragging = false;

          _animateBack(_currentAngle);
          if (_currentAngle >= (_calculateMaxAngleForNumber() * 0.95)) {
            setState(() => _numberAfterDrag = _currentNumber);
            await _playDialScrollingSound();
            await cancelVibration();
            await vibrate(1400);
            _isPlayingUpSound = false;
            if (_numberAfterDrag != null) {
              widget.onNumberSelected(_numberAfterDrag!);
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) =>
                  Transform.rotate(angle: _rotation.value, child: child),
              child: Container(
                width: widget.dimension,
                height: widget.dimension,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.beige,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...widget.numbers.map((number) {
                      final angle = _getHoleAngle(number);

                      const radius = 110.0;
                      final center = widget.dimension / 2;
                      final dx = center + radius * cos(angle);
                      final dy = center + radius * sin(angle);

                      return Positioned(
                        left: dx - 30,
                        top: dy - 30,
                        child: Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.black.withAlpha(100),
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 1500),
                                width: 60,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _numberAfterDrag == number
                                      ? AppColors.beige.withAlpha(100)
                                      : AppColors.beige,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: 18,
                              left: number == 10 ? 16 : 24,
                              child: Text(
                                '$number',
                                style: AppTextStyles.headlineSmall(
                                  fontFamily: FontFamilyEnum.body,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              right: -6,
              bottom: -8,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      // finger stop
      Positioned(
        right: 30,
        top: widget.dimension / 1.5,
        child: Transform.rotate(
          angle: 0.3,
          child: Image.asset(ImagePaths.fingerStop, width: 80, height: 80),
        ),
      ),
    ],
  );
}
