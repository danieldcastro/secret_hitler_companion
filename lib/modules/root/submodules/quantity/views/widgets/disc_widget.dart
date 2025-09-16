import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  double _currentAngle = 0;
  double? _lastAngle;
  int? _currentNumber;
  int? _numberAfterDrag;
  bool _isDragging = false;

  double? _startHoleAngle;
  final double _fingerStopAngle = 0.48; // posição fixa do stop

  final _dialPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _rotation = AlwaysStoppedAnimation(0);
    _numberAfterDrag = widget.initialNumber;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _prepareAudioPath(String path) =>
      path.startsWith('assets/') ? path.substring(7) : path;

  Future<void> _playDialUpSound() async =>
      _dialPlayer.play(AssetSource(_prepareAudioPath(AudioPaths.phoneDialUp)));

  Future<void> _playDialDownSound() async => _dialPlayer.play(
    AssetSource(_prepareAudioPath(AudioPaths.phoneDialDown)),
  );

  Future<void> _playDialScrollingSound() async => _dialPlayer.play(
    AssetSource(_prepareAudioPath(AudioPaths.phoneDialScrolling)),
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

            setState(() {
              final double maxAngleForNumber = _calculateMaxAngleForNumber();
              final double newAngle = _currentAngle + angleDiff;
              _currentAngle = newAngle.clamp(0, maxAngleForNumber);
              _rotation = AlwaysStoppedAnimation(_currentAngle);
            });
          }

          if (_currentAngle == _calculateMaxAngleForNumber()) {
            _playDialUpSound();
          }

          _lastAngle = currentTouchAngle;
        },
        onPanEnd: (_) {
          if (!_isDragging) return;

          _lastAngle = null;
          _isDragging = false;

          _animateBack(_currentAngle);
          if (_currentAngle == _calculateMaxAngleForNumber()) {
            setState(() {
              _numberAfterDrag = _currentNumber;
            });
            _playDialScrollingSound();
            if (_numberAfterDrag != null) {
              widget.onNumberSelected(_numberAfterDrag!);
            }
          }
        },
        child: AnimatedBuilder(
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
              children: [
                // centro preto
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // furos numerados
                ...widget.numbers.map((number) {
                  final angle = _getHoleAngle(number);

                  const radius = 110.0;
                  final center = widget.dimension / 2;
                  final dx = center + radius * cos(angle);
                  final dy = center + radius * sin(angle);

                  return Positioned(
                    left: dx - 30,
                    top: dy - 30,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 2),
                        color: _numberAfterDrag == number
                            ? AppColors.black.withAlpha(30)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: AppTextStyles.headlineSmall(
                            fontFamily: FontFamilyEnum.body,
                          ).copyWith(height: 1),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
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
