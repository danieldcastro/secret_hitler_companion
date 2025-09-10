import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/views/roster_page.dart';

class RosterModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addSingleton(RosterBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(AppRoutes.initial, child: (_) => RosterPage());
    super.routes(r);
  }
}
