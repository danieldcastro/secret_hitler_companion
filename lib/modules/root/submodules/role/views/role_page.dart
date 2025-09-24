import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/table_edge_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_widget.dart';

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

  @override
  void initState() {
    scheduleMicrotask(() async {
      final voters = await widget.bloc.storeVoters;
      players = voters.map((e) => e.name).toList();

      setState(() {});
    });
    super.initState();
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

  /// Calcula posições tipo wrap (linha + múltiplas linhas)
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

    // Centraliza a grade
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
                                      onTap: () =>
                                          _focusOnCard(index, screenSize),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..setEntry(3, 2, 0.005)
                                          ..rotateX(
                                            _perspectiveAnimation.value * 1.9,
                                          ),
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 400),
                                          width: cardWidth,
                                          height: cardHeight,

                                          child: EnvelopeWidget(
                                            voterName: playerName,
                                          ),
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
