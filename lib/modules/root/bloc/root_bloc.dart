import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_state.dart';

class RootBloc extends Cubit<RootState> {
  RootBloc() : super(RootState.empty());
}
