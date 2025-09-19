import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_state.dart';

class RosterBloc extends Cubit<RosterState> {
  final RootBloc rootBloc;
  RosterBloc(this.rootBloc) : super(RosterState.empty());

  void updateVoters(List<VoterEntity> voters) {
    emit(state.copyWith(voters: voters));
  }

  void updateVoterName(int index, String name) {
    if (index < 0 || index >= state.voters.length) return;

    final updatedVoters = List<VoterEntity>.from(state.voters);
    updatedVoters[index] = updatedVoters[index].copyWith(name: name);
    updateVoters(updatedVoters);
  }

  void updateRootVoters() {
    rootBloc.updateVoters(state.voters);
  }
}
