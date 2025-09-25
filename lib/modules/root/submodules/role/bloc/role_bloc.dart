import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/utils/stores/voter_store.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';

class RoleBloc extends Cubit<RoleState> {
  final VoterStore _voterStore;
  RoleBloc(this._voterStore) : super(RoleState.empty());

  Future<List<VoterEntity>> get storeVoters => _voterStore.voters;

  void toggleTearPreview() {
    emit(RoleState(showTearPreview: !state.showTearPreview));
  }
}
