import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/roster_module.dart';
import 'package:secret_hitler_companion/modules/root/views/root_page.dart';

class RootModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(RouteManager r) {
    r.child(
      AppRoutes.initial,
      child: (_) => RootPage(),
      children: [_buildChild(AppRoutes.roster, RosterModule())],
    );
    super.routes(r);
  }

  ModuleRoute _buildChild(String path, Module module) =>
      ModuleRoute(path, module: module);
}
