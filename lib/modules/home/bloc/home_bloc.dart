import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/modules/home/bloc/home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState());

  void goToQuantityPage() {
    Globals.nav.pushReplacementNamed(NestedRoutes.quantity);
  }
}
