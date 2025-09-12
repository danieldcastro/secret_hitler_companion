import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/contracts/navigation/i_nav.dart';

class Globals {
  Globals._();

  static INav get nav => Modular.get<INav>();
}
