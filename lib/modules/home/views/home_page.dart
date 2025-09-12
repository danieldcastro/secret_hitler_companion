import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/skull_button.dart';
import 'package:secret_hitler_companion/core/utils/widgets/logo_widget.dart';
import 'package:secret_hitler_companion/modules/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  final HomeBloc bloc;
  const HomePage({required this.bloc, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LogoWidget(fontSize: 80),
              ),
            ),
            Column(
              spacing: 40,
              children: [
                Text(
                  'Toque e segure para\niniciar a assembleia',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium(
                    color: AppColors.beige,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                FittedBox(child: SkullButton(onPressed: bloc.navigateToRoster)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
