import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_state.dart';

class RosterBloc extends Cubit<RosterState> {
  RosterBloc() : super(RosterState.empty());
}
