import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/modules/home/bloc/home_bloc.dart';
import 'package:secret_hitler_companion/modules/home/views/home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addSingleton(HomeBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(AppRoutes.initial, child: (_) => HomePage(bloc: Modular.get()));
    super.routes(r);
  }
}
