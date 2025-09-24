import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_state.dart';

class RootBloc extends Cubit<RootState> {
  RootBloc() : super(RootState.empty());

  void handlePop() => switch (Globals.nav.currentRoute) {
    NestedRoutes.roster => Globals.nav.navigate(NestedRoutes.quantity),
    _ => null,
  };
}
