import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/role_page_envelope_card.dart';

class RolePageCardStack extends StatelessWidget {
  final RoleBloc bloc;
  final RoleState state;
  final Size screenSize;
  final AnimationController animationController;
  final AnimationController burnController;

  const RolePageCardStack({
    required this.bloc,
    required this.state,
    required this.screenSize,
    required this.animationController,
    required this.burnController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final positions = bloc.generateCardPositions(
      screenSize,
      state.players.length,
    );

    return Stack(
      children: state.players.asMap().entries.map((entry) {
        final int index = entry.key;
        final String playerName = entry.value.name;
        final Offset position = positions[index];

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: RolePageEnvelopeCard(
            bloc: bloc,
            state: state,
            index: index,
            playerName: playerName,
            screenSize: screenSize,
            animationController: animationController,
            burnController: burnController,
          ),
        );
      }).toList(),
    );
  }
}