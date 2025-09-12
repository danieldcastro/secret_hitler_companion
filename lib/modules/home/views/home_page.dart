import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/widgets/logo_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/punch_button.dart';
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
            Flexible(child: LogoWidget(fontSize: 80)),
            FittedBox(
              child: PunchButton(
                onPressed: bloc.navigateToRoster,
                child: Text(
                  'NÃO TOQUE AQUI!',
                  style: AppTextStyles.titleSmall(color: AppColors.beige),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
