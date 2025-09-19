import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/bloc/quantity_state.dart';

class QuantityBloc extends Cubit<QuantityState> {
  final RootBloc rootBloc;
  QuantityBloc(this.rootBloc) : super(QuantityState.empty());

  void _updateVoters(List<VoterEntity> voters) {
    rootBloc.updateVoters(voters);
  }

  void _goToRosterPage() {
    Globals.nav.pushNamed(NestedRoutes.roster);
  }

  void handleSubmit(List<VoterEntity> voters) {
    _updateVoters(voters);
    _goToRosterPage();
  }
}
