import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/lottie_paths.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/envelope_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/envelope_interaction_state_enum.dart';

class RolePageEnvelopeCard extends StatelessWidget {
  final RoleBloc bloc;
  final RoleState state;
  final int index;
  final VoterEntity voter;
  final Size screenSize;
  final AnimationController animationController;
  final AnimationController burnController;

  const RolePageEnvelopeCard({
    required this.bloc,
    required this.state,
    required this.index,
    required this.voter,
    required this.screenSize,
    required this.animationController,
    required this.burnController,
    super.key,
  });

  bool get isFocused => state.focusedIndex == index;
  bool get isBurning =>
      isFocused &&
      state.currentState == EnvelopeInteractionStateEnum.showingFire;

  double get opacity {
    if (state.focusedIndex != null && !isFocused) {
      return 0.3;
    }
    return 1.0;
  }

  bool get shouldApplyBurnAnimation =>
      isFocused &&
      (state.currentState == EnvelopeInteractionStateEnum.showingFire ||
          state.currentState == EnvelopeInteractionStateEnum.complete);

  void _handleTap() {
    if (state.currentState == EnvelopeInteractionStateEnum.selectingEnvelope) {
      bloc.focusOnCard(index, screenSize, animationController);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: opacity,
    duration: Duration(milliseconds: 300),
    child: GestureDetector(
      onTap: _handleTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..rotateX(state.perspectiveAnimation?.value ?? 0 * 1),
        child: Stack(
          children: [
            _buildAnimatedEnvelope(),
            if (state.fireAnimationIndex == index) _buildFireAnimation(),
          ],
        ),
      ),
    ),
  );

  Widget _buildAnimatedEnvelope() => AnimatedBuilder(
    animation: burnController,
    builder: (context, child) => Transform.scale(
      scale: shouldApplyBurnAnimation
          ? state.burnScaleAnimation?.value ?? 1.0
          : 1.0,
      child: Transform.rotate(
        angle: shouldApplyBurnAnimation
            ? state.burnRotationAnimation?.value ?? 0.0
            : 0.0,
        child: ColorFiltered(
          colorFilter: isBurning
              ? ColorFilter.mode(
                  state.burnColorAnimation?.value ?? Colors.transparent,
                  BlendMode.modulate,
                )
              : ColorFilter.mode(Colors.transparent, BlendMode.dst),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            width: bloc.cardWidth,
            height: bloc.cardHeight,
            child: EnvelopeWidget(
              onTearComplete: () => bloc.setCanGoBack(false),
              voter: voter,
              bloc: bloc,
              flip: isFocused,
              showBurnedEnvelope: state.burnedEnvelopes.contains(index),
              onShowCardComplete: isFocused
                  ? bloc.onEnvelopeShowCardComplete
                  : null,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildFireAnimation() => Positioned(
    child: Lottie.asset(
      LottiePaths.flameFire,
      width: bloc.cardWidth,
      height: bloc.cardHeight,
      repeat: false,
    ),
  );
}
