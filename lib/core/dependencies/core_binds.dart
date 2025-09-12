import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/contracts/navigation/i_nav.dart';
import 'package:secret_hitler_companion/core/contracts/navigation/nav_impl.dart';

class CoreBinds extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<INav>(NavImpl.new);
    super.exportedBinds(i);
  }
}
