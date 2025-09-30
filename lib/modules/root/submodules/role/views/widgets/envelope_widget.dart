import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/back_envelope_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/front_envelope_widget.dart';

class EnvelopeWidget extends StatefulWidget {
  final RoleBloc bloc;
  final VoidCallback? onShowCardComplete;
  final bool showBurnedEnvelope;
  final String playerName;
  final bool flip;
  final VoidCallback? onTearComplete;

  const EnvelopeWidget({
    required this.bloc,
    required this.showBurnedEnvelope,
    required this.flip,
    required this.playerName,
    required this.onShowCardComplete,
    required this.onTearComplete,
    super.key,
  });

  final double completeThreshold = 0.50;
  final double topRegionFraction = 0.32;
  final Duration animationDuration = const Duration(milliseconds: 220);
  final bool hapticFeedback = true;

  @override
  State<EnvelopeWidget> createState() => _EnvelopeWidgetState();
}

class _EnvelopeWidgetState extends State<EnvelopeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _scaleController;
  late AnimationController _flipController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _flipAnimation;

  double _progress = 0.0;
  bool _activeDrag = false;
  bool _isComplete = false;
  double _revealOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: _progress,
    )..addListener(_onAnimationUpdate);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _flipController.value = widget.flip ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant EnvelopeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.flip != widget.flip) {
      if (widget.flip) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _scaleController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _onAnimationUpdate() {
    setState(() {
      _progress = _animController.value;
    });

    if (!_isComplete && _progress >= 1.0) {
      _isComplete = true;
      if (widget.hapticFeedback) {
        HapticFeedback.lightImpact();
      }
      _triggerCompletionBounce();
    }
  }

  void _triggerCompletionBounce() {
    _scaleController
      ..reset()
      ..forward();
  }

  void _onDragStart(DragStartDetails details, BoxConstraints constraints) {
    final topRegionHeight = constraints.maxHeight * widget.topRegionFraction;
    _activeDrag = details.localPosition.dy <= topRegionHeight && !_isComplete;

    if (_activeDrag && widget.hapticFeedback) {
      HapticFeedback.selectionClick();
    }
  }

  void _onDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (!_activeDrag) return;

    final dx = details.primaryDelta ?? 0.0;
    final deltaProgress = dx / constraints.maxWidth;
    final newValue = (_progress + deltaProgress).clamp(0.0, 1.0);
    if (_isComplete) return;
    _animController.value = newValue;
  }

  void _onDragEnd(DragEndDetails details, BoxConstraints constraints) {
    if (!_activeDrag) return;
    final dx = details.primaryVelocity ?? 0.0;
    final deltaProgress = dx / constraints.maxWidth;
    final newValue = (_progress + deltaProgress).clamp(0.0, 1.0);
    const target = 1.0;
    _animController.animateTo(
      newValue < (target / 2) ? 0 : target,
      curve: Curves.easeOut,
    );
    _activeDrag = false;
  }

  double _getScaleValue() {
    if (_progress > 0.05 && _progress < 0.3) {
      final squeezeProgress = ((_progress - 0.05) / 0.25).clamp(0.0, 1.0);
      return 1.0 - (squeezeProgress * 0.08);
    }

    if (_progress >= 0.3 && _progress < 1.0) {
      final returnProgress = ((_progress - 0.3) / 0.7).clamp(0.0, 1.0);
      return 0.92 + (returnProgress * 0.08);
    }

    if (_isComplete) {
      final bounceValue = _scaleAnimation.value;
      return 1.0 +
          (0.2 * (1.0 - (bounceValue - 0.5).abs() * 2).clamp(0.0, 1.0));
    }

    return 1.0;
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<RoleBloc, RoleState>(
    bloc: widget.bloc,
    listener: (context, state) async {},
    builder: (context, state) => AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;

        return Transform.scale(
          scale: _getScaleValue(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final revealWidth = _progress * constraints.maxWidth;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: (details) =>
                    _onDragStart(details, constraints),
                onHorizontalDragUpdate: (details) =>
                    _onDragUpdate(details, constraints),
                onHorizontalDragEnd: (details) =>
                    _onDragEnd(details, constraints),
                onVerticalDragUpdate: (details) {
                  if (_isComplete) {
                    setState(() {
                      _revealOffset = (_revealOffset + details.delta.dy).clamp(
                        -constraints.maxHeight / 2,
                        0.0,
                      );
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_isComplete) {
                    if (_revealOffset < -constraints.maxHeight / 4) {
                      widget.onShowCardComplete?.call();
                    }
                    setState(() => _revealOffset = 0.0);
                  }
                },
                child: Stack(
                  children: [
                    if (!widget.showBurnedEnvelope)
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: Opacity(
                          opacity: angle <= pi / 2
                              ? 1.0
                              : 0.0, // esconde quando "vira"
                          child: BackEnvelopeWidget(
                            playerName: widget.playerName,
                          ),
                        ),
                      ),

                    // Frente
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(widget.showBurnedEnvelope ? 0 : angle - pi),
                      child: Opacity(
                        opacity: angle > pi / 2 || widget.showBurnedEnvelope
                            ? 1.0
                            : 0.0, // aparece só depois da metade
                        child: FrontEnvelopeWidget(
                          isBurned: widget.showBurnedEnvelope,
                          progress: _progress,
                          topRegionFraction: widget.topRegionFraction,
                          revealWidth: revealWidth,
                          constraints: constraints,
                          playerName: widget.playerName,
                          revealOffset: _revealOffset,
                          isTornComplete: _isComplete,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
