import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';

class RosterPage extends StatelessWidget {
  const RosterPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Roster'),
      leading: IconButton(
        onPressed: () => Modular.to.navigate(AppRoutes.initial),
        icon: Icon(Icons.back_hand),
      ),
    ),
    body: Container(),
  );
}
