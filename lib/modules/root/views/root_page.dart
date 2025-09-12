import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: ElevatedButton(
      onPressed: () {},
      child: const Text('Open Drawer'),
    ),
    body: AdvancedDrawer(
      rtlOpening: true,
      openScale: 0.9,
      openRatio: 0.5,
      backdropColor: AppColors.beige,
      drawer: Container(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RouterOutlet(),
      ),
    ),
  );
}
