import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/modules/root/root_module.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/role_page.dart';

class RoleModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), RootModule()];

  @override
  void binds(Injector i) {
    i.addSingleton(RoleBloc.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(AppRoutes.initial, child: (_) => RolePage(bloc: Modular.get()));
    super.routes(r);
  }
}
