import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/bloc/quantity_state.dart';

class QuantityBloc extends Cubit<QuantityState> {
  QuantityBloc() : super(QuantityState.empty());
}
