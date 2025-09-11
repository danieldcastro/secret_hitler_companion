import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/app.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';
import 'package:secret_hitler_companion/core/utils/flavors/flavor_env_utils.dart';
import 'package:secret_hitler_companion/core/utils/flavors/flavors.dart';

void main() {
  Flavors.init(FlavorEnvUtils.env);
  runApp(ModularApp(module: CoreModule(), child: const App()));
}
