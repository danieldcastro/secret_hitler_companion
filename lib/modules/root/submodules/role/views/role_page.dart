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

  final double cardWidth = 50;
  final double cardHeight = 70;
  final double spacing = 20;
  final double targetZoom = 5;

  late List<String> players;

  bool _matchVisible = true; // controla se o fósforo some
  Offset _matchOffset = Offset.zero;
  bool _isDragging = false;
  Offset _dragStartPosition = Offset.zero;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      if (mounted) setState(() => focusedIndex = null);
      _animationController.reverse();
    } else {
      setState(() {
        focusedIndex = index;

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

  void _onMatchPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragStartPosition = details.localPosition;
    });
  }

  void _onMatchPanUpdate(DragUpdateDetails details) {
    setState(() {
      _matchOffset = details.localPosition - _dragStartPosition;
    });
  }

  void _onMatchPanEnd(DragEndDetails details, Size screenSize) {
    // Verifica se o fósforo foi solto sobre algum envelope
    final positions = _generateCardPositions(screenSize);
    bool droppedOnEnvelope = false;

    for (int i = 0; i < positions.length; i++) {
      final cardPosition = positions[i];
      final matchCurrentPosition = Offset(
        (positions[focusedIndex ?? 0].dx + cardWidth / 2) -
            1.5 +
            _matchOffset.dx,
        positions[focusedIndex ?? 0].dy + cardHeight + 10 + _matchOffset.dy,
      );

      // Verifica se o fósforo está sobre o envelope
      if (matchCurrentPosition.dx >= cardPosition.dx &&
          matchCurrentPosition.dx <= cardPosition.dx + cardWidth &&
          matchCurrentPosition.dy >= cardPosition.dy &&
          matchCurrentPosition.dy <= cardPosition.dy + cardHeight) {
        droppedOnEnvelope = true;
        break;
      }
    }

    setState(() {
      _isDragging = false;
    });

    if (droppedOnEnvelope) {
      // Se foi solto sobre envelope, faz o fósforo sair da tela para baixo
      setState(() {
        _matchOffset = Offset(0, 40); // Move para fora da tela
      });

      // Depois da animação de saída, desaparece
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _matchVisible = false;
          });
        }
      });
    } else {
      // Se não foi solto sobre envelope, volta para posição inicial
      setState(() {
        _matchOffset = Offset.zero;
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
                if (focusedIndex != null) {
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
                                        if (focusedIndex == null ||
                                            focusedIndex == index) {
                                          _focusOnCard(index, screenSize);
                                          widget.bloc.toggleTearPreview();
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
                                            AnimatedContainer(
                                              duration: Duration(
                                                milliseconds: 400,
                                              ),
                                              width: cardWidth,
                                              height: cardHeight,
                                              child: EnvelopeTearWidget(
                                                bloc: widget.bloc,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 2,
                                              child: Lottie.asset(
                                                LottiePaths.flameFire,
                                                animate: !_matchVisible,
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
                              // fósforo
                              if (_matchVisible)
                                AnimatedPositioned(
                                  duration: _isDragging
                                      ? Duration.zero
                                      : const Duration(milliseconds: 600),
                                  curve: Curves.easeInBack,
                                  left:
                                      (positions[focusedIndex ?? 0].dx +
                                          cardWidth / 2) -
                                      1.5 +
                                      _matchOffset.dx,
                                  top:
                                      positions[focusedIndex ?? 0].dy +
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
