import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/skull_button.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/paper_widget.dart';

class RosterFooter extends StatelessWidget {
  final bool isAllNamesFilled;
  const RosterFooter({required this.isAllNamesFilled, super.key});

  @override
  Widget build(BuildContext context) => AnimatedSlide(
    offset: KeyboardVisibilityProvider.isKeyboardVisible(context)
        ? Offset(0, 1)
        : Offset.zero,
    duration: const Duration(milliseconds: 300),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: KeyboardVisibilityProvider.isKeyboardVisible(context) ? 0 : 200,
      color: Color(0xFFB8431C),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedSlide(
            offset: isAllNamesFilled ? Offset.zero : Offset(0, 1),
            curve: Curves.elasticInOut,
            duration: const Duration(milliseconds: 2000),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: FittedBox(child: SkullButton(onPressed: () {})),
            ),
          ),

          AnimatedSlide(
            offset: isAllNamesFilled ? Offset(0, 1) : Offset.zero,
            curve: Curves.elasticInOut,
            duration: const Duration(milliseconds: 2000),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: PaperWidget(title: context.loc.rosterPageMessage),
            ),
          ),
        ],
      ),
    ),
  );
}
