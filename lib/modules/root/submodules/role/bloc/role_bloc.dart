import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';

class RoleBloc extends Cubit<RoleState> {
  RoleBloc() : super(RoleState.empty());
}
