import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/stores/voter_store.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/bloc/quantity_state.dart';

class QuantityBloc extends Cubit<QuantityState> {
  final VoterStore _voterStore;
  QuantityBloc(this._voterStore) : super(QuantityState.empty());

  Future<int> get storeQuantity async {
    final currentVoters = await _voterStore.getVoters();

    if (currentVoters.isNotEmpty) {
      return currentVoters.length;
    }
    return 5;
  }

  Future<void> _updateVoters(List<VoterEntity> voters) async {
    final currentVoters = await _voterStore.getVoters();

    var localVoters = List<VoterEntity>.from(currentVoters);
    if (voters.length < currentVoters.length) {
      localVoters = localVoters.sublist(0, voters.length);
    } else if (voters.length > currentVoters.length) {
      final difference = voters.length - currentVoters.length;
      final newVoters = List.generate(
        difference,
        (index) => VoterEntity.empty(),
      );
      localVoters = [...currentVoters, ...newVoters];
    } else {
      localVoters = currentVoters;
    }
    _voterStore.updateVoters(localVoters);
  }

  void _goToRosterPage() {
    Globals.nav.pushNamed(NestedRoutes.roster);
  }

  void handleSubmit(List<VoterEntity> voters) {
    _updateVoters(voters);
    _goToRosterPage();
  }
}
