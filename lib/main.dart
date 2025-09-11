import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/app.dart';
import 'package:secret_hitler_companion/core/dependencies/core_module.dart';

void main() {
  runApp(ModularApp(module: CoreModule(), child: const App()));
}
