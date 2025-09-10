import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/dependencies/core_binds.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/modules/root/root_module.dart';

class CoreModule extends Module {
  @override
  List<Module> get imports => [CoreBinds()];

  @override
  void routes(RouteManager r) {
    r.module(AppRoutes.initial, module: RootModule());
    super.routes(r);
  }
}
