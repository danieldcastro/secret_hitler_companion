import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/skull_button.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/logo_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/paper_widget.dart';
import 'package:secret_hitler_companion/modules/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  final HomeBloc bloc;
  const HomePage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
                child: LogoWidget(fontSize: 80),
              ),
            ),
            Column(
              spacing: 40,
              children: [
                PaperWidget(title: context.loc.holdButtonMessage),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SkullButton(onPressed: bloc.goToQuantityPage),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
