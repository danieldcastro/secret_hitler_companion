import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/lottie_paths.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/table_edge_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_tear_widget.dart';

enum InteractionState {
  selectingEnvelope,
  tearingEnvelope,
  waitingForMatch,
  draggingMatch,
  showingFire,
  complete,
}

class RolePage extends StatefulWidget {
  final RoleBloc bloc;
  const RolePage({required this.bloc, super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> with TickerProviderStateMixin {
  int? focusedIndex;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _perspectiveAnimation;
  late Animation<Offset> _offsetAnimation;

  // Controller para animação de queimada
  late AnimationController _burnController;
  late Animation<double> _burnScaleAnimation;
  late Animation<double> _burnRotationAnimation;
  late Animation<Color?> _burnColorAnimation;

  final double cardWidth = 50;
  final double cardHeight = 70;
  final double spacing = 20;
  final double targetZoom = 5;

  late List<String> players;

  InteractionState _currentState = InteractionState.selectingEnvelope;
  bool _matchVisible = false;
  Offset _matchOffset = Offset.zero;
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;
  int? _fireAnimationIndex;
  bool _envelopeTorn = false;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      final voters = await widget.bloc.storeVoters;
      players = voters.map((e) => e.name).toList();
      setState(() {});
    });

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: targetZoom).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _perspectiveAnimation = Tween<double>(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);

    // Animação de queimada realista
    _burnController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    // Escala: encolhe gradualmente como papel queimando e depois retorna
    _burnScaleAnimation = TweenSequence<double>([
      // Pequena expansão inicial (papel aquecendo)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      // Encolhimento progressivo (queimando)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 0.75,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      // Encolhimento mais rápido (consumido pelo fogo)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.75,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 30,
      ),
      // Retorna para escala normal (mostra envelope queimado)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_burnController);

    // Rotação sutil para simular deformação do papel
    _burnRotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.02),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.02, end: -0.03),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.03, end: 0.01),
        weight: 30,
      ),
    ]).animate(_burnController);

    // Mudança de cor para simular carbonização
    _burnColorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.white.withOpacity(1.0),
          end: Color(0xFFD4A574).withOpacity(0.9), // Marrom claro
        ),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Color(0xFFD4A574).withOpacity(0.9),
          end: Color(0xFF8B4513).withOpacity(0.7), // Marrom escuro
        ),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Color(0xFF8B4513).withOpacity(0.7),
          end: Color(0xFF1a1a1a).withOpacity(0.3), // Quase preto/cinza
        ),
        weight: 50,
      ),
    ]).animate(_burnController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _burnController.dispose();
    super.dispose();
  }

  List<Offset> _generateCardPositions(Size screenSize) {
    final positions = <Offset>[];
    final cardsPerRow = (screenSize.width ~/ (cardWidth + spacing)).clamp(
      1,
      players.length,
    );
    for (int i = 0; i < players.length; i++) {
      final int row = i ~/ cardsPerRow;
      final int col = i % cardsPerRow;
      final double x = col * (cardWidth + spacing);
      final double y = row * (cardHeight + spacing);
      positions.add(Offset(x, y));
    }

    final int totalRows = (players.length / cardsPerRow).ceil();
    final double gridWidth = (cardsPerRow * (cardWidth + spacing)) - spacing;
    final double gridHeight = (totalRows * (cardHeight + spacing)) - spacing;
    final Offset centerOffset = Offset(
      (screenSize.width - gridWidth) / 2,
      (screenSize.height - gridHeight) - 230,
    );

    return positions.map((pos) => pos + centerOffset).toList();
  }

  void _focusOnCard(int index, Size screenSize) {
    final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);
    final positions = _generateCardPositions(screenSize);

    if (focusedIndex == index) {
      if (mounted) {
        setState(() {
          focusedIndex = null;
          _currentState = InteractionState.selectingEnvelope;
        });
      }
      _animationController.reverse();
    } else {
      setState(() {
        focusedIndex = index;
        _currentState = InteractionState.tearingEnvelope;
        _envelopeTorn = false;

        final cardCenter = Offset(
          positions[index].dx + cardWidth / 2,
          positions[index].dy + cardHeight / 2,
        );

        final targetOffset = Offset(
          screenCenter.dx / targetZoom - cardCenter.dx,
          screenCenter.dy / targetZoom - cardCenter.dy,
        );

        _offsetAnimation =
            Tween<Offset>(
              begin: _offsetAnimation.value,
              end: targetOffset,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOutCubic,
              ),
            );
      });

      _animationController.forward(from: 0);
    }
  }

  void _onEnvelopeTearComplete() {
    if (_currentState == InteractionState.tearingEnvelope) {
      setState(() {
        _currentState = InteractionState.waitingForMatch;
        _envelopeTorn = true;
        _matchVisible = true;
        _matchOffset = Offset(0, 70);
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _matchOffset = Offset.zero;
          });
        }
      });
    }
  }

  void _onMatchPanStart(DragStartDetails details) {
    if (_currentState != InteractionState.waitingForMatch) return;

    setState(() {
      _isDragging = true;
      _dragStartPosition = details.localPosition;
      _currentState = InteractionState.draggingMatch;
    });
  }

  void _onMatchPanUpdate(DragUpdateDetails details) {
    if (_currentState != InteractionState.draggingMatch) return;

    setState(() {
      _matchOffset = details.localPosition - _dragStartPosition;
    });
  }

  void _onMatchPanEnd(DragEndDetails details, Size screenSize) {
    if (_currentState != InteractionState.draggingMatch) return;

    final positions = _generateCardPositions(screenSize);
    bool droppedOnFocusedEnvelope = false;

    if (focusedIndex != null) {
      final cardPosition = positions[focusedIndex!];
      final matchCurrentPosition = Offset(
        (positions[focusedIndex!].dx + cardWidth / 2) - 1.5 + _matchOffset.dx,
        positions[focusedIndex!].dy + cardHeight + 10 + _matchOffset.dy,
      );

      if (matchCurrentPosition.dx >= cardPosition.dx &&
          matchCurrentPosition.dx <= cardPosition.dx + cardWidth &&
          matchCurrentPosition.dy >= cardPosition.dy &&
          matchCurrentPosition.dy <= cardPosition.dy + cardHeight) {
        droppedOnFocusedEnvelope = true;
      }
    }

    setState(() {
      _isDragging = false;
    });

    if (droppedOnFocusedEnvelope && focusedIndex != null) {
      setState(() {
        _currentState = InteractionState.showingFire;
        _fireAnimationIndex = focusedIndex;
      });

      // Inicia animação de queimada
      _burnController.forward(from: 0);

      setState(() {
        _matchOffset = Offset(0, 70);
      });

      // Esconde o fósforo
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _matchVisible = false);
        }
      });

      // Troca para envelope queimado no ponto de menor escala (70% da animação = 1260ms)
      Future.delayed(Duration(milliseconds: 1260), () {
        if (mounted) {
          setState(() {
            _currentState = InteractionState.complete;
          });
        }
      });
    } else {
      setState(() {
        _matchOffset = Offset.zero;
        _currentState = InteractionState.waitingForMatch;
      });
    }
  }

  Widget _buildMatch() => AnimatedOpacity(
    duration: const Duration(milliseconds: 400),
    opacity: _matchVisible ? 1 : 0,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -20,
          left: -11,
          child: Lottie.asset(LottiePaths.fire, height: 25),
        ),
        Image.asset(ImagePaths.match, height: 30),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final positions = _generateCardPositions(screenSize);

    return AppScaffold(
      onBack: () {
        if (focusedIndex != null) {
          _focusOnCard(focusedIndex!, screenSize);
          return;
        }
        Globals.nav.navigate(NestedRoutes.roster);
      },
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (focusedIndex != null &&
                    (_currentState == InteractionState.selectingEnvelope ||
                        _currentState == InteractionState.tearingEnvelope ||
                        _currentState == InteractionState.complete)) {
                  _focusOnCard(focusedIndex!, screenSize);
                }
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.topLeft,
                  child: Transform.translate(
                    offset: _offsetAnimation.value,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ...players.asMap().entries.map((entry) {
                                    final int index = entry.key;
                                    final String playerName = entry.value;
                                    final Offset position = positions[index];
                                    final isBurning =
                                        focusedIndex == index &&
                                        _currentState ==
                                            InteractionState.showingFire;

                                    return Positioned(
                                      left: position.dx,
                                      top: position.dy,
                                      child: AnimatedOpacity(
                                        opacity:
                                            focusedIndex != null &&
                                                focusedIndex != index
                                            ? 0.3
                                            : 1.0,
                                        duration: Duration(milliseconds: 300),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_currentState ==
                                                InteractionState
                                                    .selectingEnvelope) {
                                              _focusOnCard(index, screenSize);
                                            }
                                          },
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.005)
                                              ..rotateX(
                                                _perspectiveAnimation.value *
                                                    1.9,
                                              ),
                                            child: Stack(
                                              children: [
                                                // Envelope com animações de queimada
                                                AnimatedBuilder(
                                                  animation: _burnController,
                                                  builder: (context, child) {
                                                    final shouldApplyBurnAnimation =
                                                        focusedIndex == index &&
                                                        (_currentState ==
                                                                InteractionState
                                                                    .showingFire ||
                                                            _currentState ==
                                                                InteractionState
                                                                    .complete);

                                                    return Transform.scale(
                                                      scale:
                                                          shouldApplyBurnAnimation
                                                          ? _burnScaleAnimation
                                                                .value
                                                          : 1.0,
                                                      child: Transform.rotate(
                                                        angle:
                                                            shouldApplyBurnAnimation
                                                            ? _burnRotationAnimation
                                                                  .value
                                                            : 0.0,
                                                        child: ColorFiltered(
                                                          colorFilter: isBurning
                                                              ? ColorFilter.mode(
                                                                  _burnColorAnimation
                                                                          .value ??
                                                                      Colors
                                                                          .transparent,
                                                                  BlendMode
                                                                      .modulate,
                                                                )
                                                              : ColorFilter.mode(
                                                                  Colors
                                                                      .transparent,
                                                                  BlendMode.dst,
                                                                ),
                                                          child: AnimatedContainer(
                                                            duration: Duration(
                                                              milliseconds: 400,
                                                            ),
                                                            width: cardWidth,
                                                            height: cardHeight,
                                                            child: EnvelopeTearWidget(
                                                              bloc: widget.bloc,
                                                              showBurnedEnvelope:
                                                                  focusedIndex ==
                                                                      index &&
                                                                  _currentState ==
                                                                      InteractionState
                                                                          .complete,
                                                              onTearComplete:
                                                                  focusedIndex ==
                                                                      index
                                                                  ? _onEnvelopeTearComplete
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                // Animação de fogo
                                                if (_fireAnimationIndex ==
                                                    index)
                                                  Positioned(
                                                    child: Lottie.asset(
                                                      LottiePaths.flameFire,
                                                      width: cardWidth,
                                                      height: cardHeight,
                                                      repeat: false,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                TableEdgeWidget(),
                                FooterWidget(
                                  onTap: () {},
                                  backgroundColor: AppColors.darkPropRed,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_matchVisible && focusedIndex != null)
                          AnimatedPositioned(
                            duration: _isDragging
                                ? Duration.zero
                                : const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            left:
                                (positions[focusedIndex!].dx + cardWidth / 2) -
                                1.5 +
                                _matchOffset.dx,
                            top:
                                positions[focusedIndex!].dy +
                                cardHeight +
                                10 +
                                _matchOffset.dy,
                            child: GestureDetector(
                              onPanStart: _onMatchPanStart,
                              onPanUpdate: _onMatchPanUpdate,
                              onPanEnd: (details) =>
                                  _onMatchPanEnd(details, screenSize),
                              child: Transform.scale(
                                scale: _isDragging ? 1.2 : 1.0,
                                child: _buildMatch(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
