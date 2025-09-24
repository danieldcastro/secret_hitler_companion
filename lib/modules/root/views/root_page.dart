import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_bloc.dart';

class RootPage extends StatelessWidget {
  final RootBloc bloc;
  const RootPage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) =>
      AppScaffold(onBack: bloc.handlePop, body: RouterOutlet());
}
