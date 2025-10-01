import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/table_edge_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/role_page_card_stack.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/role_page_match_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/role_page_table_surface.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/envelope_interaction_state_enum.dart';

class RolePage extends StatefulWidget {
  final RoleBloc bloc;
  const RolePage({required this.bloc, super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _burnController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 600),
      vsync: this,
    );

    _burnController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    scheduleMicrotask(
      () => widget.bloc.setInitialData(_animationController, _burnController),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _burnController.dispose();
    super.dispose();
  }

  void _handleBack(RoleState state, Size screenSize) {
    if (!state.canGoBack) return;

    if (state.focusedIndex != null) {
      widget.bloc.focusOnCard(
        state.focusedIndex!,
        screenSize,
        _animationController,
      );
      return;
    }
    Globals.nav.navigate(NestedRoutes.roster);
  }

  void _handleTapOutside(RoleState state, Size screenSize) {
    if (state.focusedIndex == null) return;

    final canTapOutside =
        state.currentState == EnvelopeInteractionStateEnum.selectingEnvelope ||
        state.currentState == EnvelopeInteractionStateEnum.tearingEnvelope ||
        state.currentState == EnvelopeInteractionStateEnum.complete;

    if (canTapOutside) {
      widget.bloc.focusOnCard(
        state.focusedIndex!,
        screenSize,
        _animationController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<RoleBloc, RoleState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (!state.hasPlayers) {
          return AppScaffold(
            onBack: () => Globals.nav.navigate(NestedRoutes.roster),
            showBackButton: true,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AppScaffold(
          onBack: () => _handleBack(state, screenSize),
          showBackButton: state.canGoBack,
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleTapOutside(state, screenSize),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => Transform.scale(
                      scale: state.scaleAnimation?.value,
                      alignment: Alignment.topLeft,
                      child: Transform.translate(
                        offset: state.offsetAnimation?.value ?? Offset.zero,
                        child: Stack(
                          children: [
                            _buildMainContent(context, state, screenSize),
                            if (state.matchVisible &&
                                state.focusedIndex != null)
                              _buildMatchWidget(state, screenSize),
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
      },
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    RoleState state,
    Size screenSize,
  ) => Column(
    children: [
      Expanded(
        child: Stack(
          children: [
            RolePageTableSurface(),
            RolePageCardStack(
              bloc: widget.bloc,
              state: state,
              screenSize: screenSize,
              animationController: _animationController,
              burnController: _burnController,
            ),
          ],
        ),
      ),
      _buildFooter(context, state),
    ],
  );

  Widget _buildFooter(BuildContext context, RoleState state) => Column(
    children: [
      TableEdgeWidget(),
      FooterWidget(
        onTap: () {},
        showButton: state.allEnvelopesBurned,
        message: context.loc.rolePageMessage,
        backgroundColor: AppColors.darkPropRed,
      ),
    ],
  );

  Widget _buildMatchWidget(RoleState state, Size screenSize) {
    final positions = widget.bloc.generateCardPositions(
      screenSize,
      state.players.length,
    );

    return AnimatedPositioned(
      duration: state.isDragging
          ? Duration.zero
          : const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      left:
          (positions[state.focusedIndex!].dx + widget.bloc.cardWidth / 2) -
          1.5 +
          state.matchOffset.dx,
      top:
          positions[state.focusedIndex!].dy +
          widget.bloc.cardHeight +
          10 +
          state.matchOffset.dy,
      child: GestureDetector(
        onPanStart: (details) =>
            widget.bloc.startMatchDrag(details.localPosition),
        onPanUpdate: (details) =>
            widget.bloc.updateMatchDrag(details.localPosition),
        onPanEnd: (details) => widget.bloc.onMatchPanEnd(
          details,
          screenSize,
          _animationController,
          _burnController,
        ),
        child: Transform.scale(
          scale: state.isDragging ? 1.2 : 1.0,
          child: RolePageMatchWidget(visible: state.matchVisible),
        ),
      ),
    );
  }
}
