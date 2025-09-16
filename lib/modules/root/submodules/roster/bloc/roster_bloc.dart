import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_state.dart';

class RosterBloc extends Cubit<RosterState> {
  final RootBloc rootBloc;
  RosterBloc(this.rootBloc) : super(RosterState.empty());

  final List<TextEditingController> controllers = [TextEditingController()];
}
