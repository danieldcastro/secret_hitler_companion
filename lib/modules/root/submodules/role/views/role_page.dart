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

// Estados do fluxo de interação
enum InteractionState {
  selectingEnvelope, // Usuário pode selecionar um envelope
  tearingEnvelope, // Usuário deve rasgar o envelope selecionado
  waitingForMatch, // Fósforo aparece, usuário deve arrastá-lo
  draggingMatch, // Usuário está arrastando o fósforo
  showingFire, // Animação de fogo sendo exibida
  transitioning, // Animação de transição (escala pequena -> pulo)
  complete, // Sequência completa
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

  // Controller para a animação de transição do envelope
  late AnimationController _transitionController;
  late Animation<double> _transitionScaleAnimation;
  late Animation<double> _transitionBounceAnimation;

  final double cardWidth = 50;
  final double cardHeight = 70;
  final double spacing = 20;
  final double targetZoom = 5;

  late List<String> players;

  // Estados do fluxo de interação
  InteractionState _currentState = InteractionState.selectingEnvelope;
  bool _matchVisible = false;
  Offset _matchOffset = Offset.zero;
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;
  int?
  _fireAnimationIndex; // Índice do envelope que deve mostrar a animação de fogo
  bool _envelopeTorn = false; // Controla se o envelope foi rasgado

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

    // Controller para animação de transição do envelope
    _transitionController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animação de escala (diminui e depois aumenta com bounce)
    _transitionScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70.0,
      ),
    ]).animate(_transitionController);

    // Animação de bounce adicional para dar o efeito de "pulo"
    _transitionBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30.0),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -8.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -8.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 35.0,
      ),
    ]).animate(_transitionController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transitionController.dispose();
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
    // Só permite focar se estiver no estado de seleção
    if (_currentState != InteractionState.selectingEnvelope) return;

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

  // Callback chamado quando o envelope é completamente rasgado
  void _onEnvelopeTearComplete() {
    if (_currentState == InteractionState.tearingEnvelope) {
      setState(() {
        _currentState = InteractionState.waitingForMatch;
        _envelopeTorn = true;
        _matchVisible = true;
        _matchOffset = Offset(0, 100); // Começa fora da tela (abaixo)
      });

      // Anima o fósforo entrando na tela
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _matchOffset = Offset.zero; // Move para posição inicial
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

    // Verifica se o fósforo foi solto sobre o envelope focado
    final positions = _generateCardPositions(screenSize);
    bool droppedOnFocusedEnvelope = false;

    if (focusedIndex != null) {
      final cardPosition = positions[focusedIndex!];
      final matchCurrentPosition = Offset(
        (positions[focusedIndex!].dx + cardWidth / 2) - 1.5 + _matchOffset.dx,
        positions[focusedIndex!].dy + cardHeight + 10 + _matchOffset.dy,
      );

      // Verifica se o fósforo está sobre o envelope focado
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
      // Fósforo foi solto sobre o envelope correto
      setState(() {
        _currentState = InteractionState.showingFire;
        _fireAnimationIndex = focusedIndex;
      });

      // Faz o fósforo sair da tela
      setState(() {
        _matchOffset = Offset(0, 100); // Move para fora da tela
      });

      // Depois da animação de saída, desaparece
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _matchVisible = false;
          });
        }
      });

      // Após a animação de fogo (assumindo duração de 2 segundos), inicia transição
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _currentState = InteractionState.transitioning;
            _fireAnimationIndex = null;
          });

          // Inicia a animação de transição
          _transitionController.forward().then((_) {
            if (mounted) {
              setState(() {
                _currentState = InteractionState.complete;
              });
            }
          });
        }
      });
    } else {
      // Se não foi solto sobre o envelope correto, volta para posição inicial
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
      onBack: () => Globals.nav.navigate(NestedRoutes.roster),
      showBackButton: true,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Só permite desfoque se estiver no estado de seleção ou rasgo
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
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ...players.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final String playerName = entry.value;
                                final Offset position = positions[index];

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
                                            _perspectiveAnimation.value * 1.9,
                                          ),
                                        child: Stack(
                                          children: [
                                            // Envelope com animação de transição
                                            AnimatedBuilder(
                                              animation: _transitionController,
                                              builder: (context, child) {
                                                // Aplica animações de transição apenas no envelope focado
                                                final shouldAnimate =
                                                    focusedIndex == index &&
                                                    _currentState ==
                                                        InteractionState
                                                            .transitioning;

                                                return Transform.translate(
                                                  offset: shouldAnimate
                                                      ? Offset(
                                                          0,
                                                          _transitionBounceAnimation
                                                              .value,
                                                        )
                                                      : Offset.zero,
                                                  child: Transform.scale(
                                                    scale: shouldAnimate
                                                        ? _transitionScaleAnimation
                                                              .value
                                                        : 1.0,
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
                                                            (_currentState ==
                                                                    InteractionState
                                                                        .complete ||
                                                                _currentState ==
                                                                    InteractionState
                                                                        .transitioning),
                                                        onTearComplete:
                                                            focusedIndex ==
                                                                index
                                                            ? _onEnvelopeTearComplete
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Só mostra a animação de fogo no envelope correto
                                            if (_fireAnimationIndex == index &&
                                                _currentState ==
                                                    InteractionState
                                                        .showingFire)
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
                              // Fósforo - só aparece após envelope ser rasgado
                              if (_matchVisible && focusedIndex != null)
                                AnimatedPositioned(
                                  duration: _isDragging
                                      ? Duration.zero
                                      : const Duration(milliseconds: 600),
                                  curve: Curves.easeInBack,
                                  left:
                                      (positions[focusedIndex!].dx +
                                          cardWidth / 2) -
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
