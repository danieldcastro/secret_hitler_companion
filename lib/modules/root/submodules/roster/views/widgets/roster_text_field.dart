import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';

class RosterTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const RosterTextField({
    required this.controller,
    super.key,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    focusNode: focusNode,
    cursorHeight: 20,
    style: AppTextStyles.titleLarge().copyWith(height: 1),
    maxLength: 15,
    textInputAction: TextInputAction.newline,
    keyboardType: TextInputType.name,
    textCapitalization: TextCapitalization.characters,
    decoration: InputDecoration(
      hintText: context.loc.voterNameHint.toUpperCase(),
    ),
    onChanged: onChanged,
  );
}
