import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/enums/font_family_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';

class EnvelopeTearWidget extends StatefulWidget {
  final RoleBloc bloc;
  final VoidCallback? onTearComplete;
  final bool showBurnedEnvelope;
  final String playerName;
  final bool flip;

  const EnvelopeTearWidget({
    required this.bloc,
    required this.showBurnedEnvelope,
    required this.flip,
    required this.playerName,
    this.onTearComplete,
    super.key,
  });

  final double completeThreshold = 0.50;
  final double topRegionFraction = 0.32;
  final Duration animationDuration = const Duration(milliseconds: 220);
  final bool hapticFeedback = true;

  @override
  State<EnvelopeTearWidget> createState() => _EnvelopeTearWidgetState();
}

class _EnvelopeTearWidgetState extends State<EnvelopeTearWidget>
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

    // Estado inicial: se flip é true, começa com valor 1.0 (frente)
    // se flip é false, começa com valor 0.0 (verso)
    _flipController.value = widget.flip ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant EnvelopeTearWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.flip != widget.flip) {
      if (widget.flip) {
        // Virar para a frente (esquerda): de 0 para 1
        _flipController.forward();
      } else {
        // Virar para o verso (direita): de 1 para 0
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

  void _onDragEnd(DragEndDetails details) {
    if (!_activeDrag) return;

    const target = 1.0;
    _animController.animateTo(target, curve: Curves.easeOut);
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
        // Ângulo baseado na animação
        // Quando _flipAnimation.value = 0 (flip=false): ângulo = 0 (mostra verso)
        // Quando _flipAnimation.value = 1 (flip=true): ângulo = pi (mostra frente)
        // Usamos ângulo POSITIVO para rotacionar no eixo Y (vira da direita para esquerda)
        final angle = _flipAnimation.value * pi;

        // Determina qual lado está visível
        // Entre 0 e pi/2: mostra verso
        // Entre pi/2 e pi: mostra frente (já passou da metade da virada)
        final isShowingFront = angle > (pi / 2);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: Transform.scale(
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
                  onHorizontalDragEnd: _onDragEnd,
                  onVerticalDragUpdate: (details) {
                    if (_isComplete) {
                      setState(() {
                        _revealOffset = (_revealOffset + details.delta.dy)
                            .clamp(-constraints.maxHeight / 2, 0.0);
                      });
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (_isComplete) {
                      if (_revealOffset < -constraints.maxHeight / 4) {
                        widget.onTearComplete?.call();
                        setState(() => _revealOffset = 0.0);
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      if (widget.showBurnedEnvelope)
                        Image.asset(
                          ImagePaths.burnedEnvelope,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      else if (!isShowingFront)
                        // Mostra o verso (backEnvelope) quando flip = false
                        Stack(
                          children: [
                            Image.asset(
                              ImagePaths.backEnvelope,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned.fill(
                              child: Center(
                                child: FittedBox(
                                  child: Transform.rotate(
                                    angle: -0.7,
                                    child: Text(
                                      widget.playerName,
                                      style: AppTextStyles.headlineMedium(
                                        fontFamily: FontFamilyEnum.handmade,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                      // Mostra a frente (straightEnvelope) quando flip = true
                      ...[
                        Image.asset(
                          ImagePaths.straightEnvelope,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        if (_progress == 1)
                          Image.asset(
                            ImagePaths.tornEnvelope,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        if (_progress > 0.1)
                          ClipPath(
                            clipper: _ProgressiveClipper(
                              revealWidth: revealWidth,
                            ),
                            child: Image.asset(
                              ImagePaths.tornEnvelope,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        if (_progress > 0.1 && _progress < 0.99)
                          CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: _TornFlapEdgePainter(
                              progress: _progress,
                              topRegionFraction: widget.topRegionFraction,
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}

class _ProgressiveClipper extends CustomClipper<Path> {
  const _ProgressiveClipper({required this.revealWidth});

  final double revealWidth;

  @override
  Path getClip(Size size) {
    final maxWidth = revealWidth.clamp(0.0, size.width);
    final path = Path();
    if (maxWidth <= 0) return path;

    const flapBottomY = 5.0;
    final rng = Random(12345);
    final segments = (maxWidth / 5).ceil().clamp(1, 9999);
    final segmentWidth = maxWidth / segments;

    path
      ..moveTo(0, 0)
      ..lineTo(0, flapBottomY);

    for (int i = 0; i < segments; i++) {
      final currentX = (i + 1) * segmentWidth;
      final yVariation = (rng.nextDouble() - 0.5) * 2;
      final targetY = flapBottomY + yVariation;
      final controlX1 = currentX - segmentWidth * 0.5;
      final controlY1 = flapBottomY + (rng.nextDouble() - 0.5) * 8;
      path.quadraticBezierTo(controlX1, controlY1, currentX, targetY);
    }

    path
      ..lineTo(maxWidth, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant _ProgressiveClipper oldClipper) =>
      oldClipper.revealWidth != revealWidth;
}

class _TornFlapEdgePainter extends CustomPainter {
  const _TornFlapEdgePainter({
    required this.progress,
    required this.topRegionFraction,
  });

  final double progress;
  final double topRegionFraction;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    const flapBottomY = 5.0;
    const leftPadding = 2.0;
    final maxWidth = size.width * progress;

    final paint = Paint()
      ..color = AppColors.black.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = AppColors.paper.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final highlightPaint = Paint()
      ..color = AppColors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final path = Path();
    final shadowPath = Path();
    final highlightPath = Path();

    final startX = maxWidth;
    if (startX <= 0) return;

    final segments = (startX / 4).ceil();
    if (segments <= 0) return;

    final segmentWidth = startX / segments;

    path.moveTo(leftPadding, flapBottomY);
    shadowPath.moveTo(leftPadding, flapBottomY + 0.3);
    highlightPath.moveTo(leftPadding, flapBottomY - 0.3);

    final rng = Random(12345);

    for (int i = 0; i < segments; i++) {
      final currentX = (i + 1) * segmentWidth;
      final yVariation = (rng.nextDouble() - 0.5) * 1.5;
      final targetY = flapBottomY + yVariation;
      final controlX1 = currentX - segmentWidth * 0.3;
      final controlY1 = flapBottomY + (rng.nextDouble() - 0.5) * 3;

      path.quadraticBezierTo(controlX1, controlY1, currentX, targetY);
      shadowPath.quadraticBezierTo(
        controlX1,
        controlY1 + 0.3,
        currentX,
        targetY + 0.3,
      );
      highlightPath.quadraticBezierTo(
        controlX1,
        controlY1 - 0.3,
        currentX,
        targetY - 0.3,
      );
    }

    if (progress > 0.05) {
      canvas
        ..drawPath(shadowPath, shadowPaint)
        ..drawPath(path, paint)
        ..drawPath(highlightPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TornFlapEdgePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.topRegionFraction != topRegionFraction;
}
