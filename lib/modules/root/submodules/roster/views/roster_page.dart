import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

class RosterPage extends StatelessWidget {
  const RosterPage({super.key});

  double get _paperHeight => 80; //80
  double get _paperWidth => 300;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 110,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: _paperWidth,
            height: _paperHeight,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(20),
              // border: Border.all(color: AppColors.black, width: 4),
            ),
          ),
        ),
        Positioned(
          top: -90,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Transform.rotate(
                angle: 180 * 3.14 / 180,
                child: Image.asset(ImagePaths.typewriter),
              ),
            ),
          ),
        ),
        Positioned(
          top: 114,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: _paperWidth - 8,
            height: _paperHeight - 8,
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                spacing: 20,
                children: [
                  TextFormField(
                    cursorHeight: 20,
                    style: AppTextStyles.titleLarge().copyWith(height: 1),
                    maxLength: 15,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(hintText: 'NOME DO VOTANTE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
