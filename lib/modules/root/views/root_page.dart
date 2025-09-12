import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AdvancedDrawer(drawer: Container(), child: RouterOutlet()),
  );
}
