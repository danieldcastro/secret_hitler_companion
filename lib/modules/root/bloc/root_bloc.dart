import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_state.dart';

class RootBloc extends Cubit<RootState> {
  RootBloc() : super(RootState.empty());

  void updateVoters(List<VoterEntity> voters) {
    emit(state.copyWith(voters: voters));
  }

  void addVoterByName(String name) {
    if (name.trim().isEmpty) return;

    final voter = VoterEntity(name: name.trim());
    final updatedVoters = [...state.voters, voter];
    emit(state.copyWith(voters: updatedVoters));
  }

  void updateVoterName(int index, String name) {
    if (index < 0 || index >= state.voters.length) return;

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      removeVoterByIndex(index);
      return;
    }

    final updatedVoters = List<VoterEntity>.from(state.voters);
    updatedVoters[index] = updatedVoters[index].copyWith(name: trimmedName);
    emit(state.copyWith(voters: updatedVoters));
  }

  void removeVoterByIndex(int index) {
    if (index < 0 || index >= state.voters.length) return;

    final updatedVoters = [...state.voters]..removeAt(index);
    emit(state.copyWith(voters: updatedVoters));
  }
}
