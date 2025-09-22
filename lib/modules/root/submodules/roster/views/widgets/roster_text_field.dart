import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secret_hitler_companion/core/objects/enums/audio_key_enum.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/themes/app_text_styles.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/mixins/vibrator_mixin.dart';

class RosterTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int index;

  const RosterTextField({
    required this.controller,
    required this.index,
    super.key,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<RosterTextField> createState() => _RosterTextFieldState();
}

class _RosterTextFieldState extends State<RosterTextField>
    with AudioMixin, VibratorMixin {
  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      await createPool(AudioKeyEnum.keyboardTap, AudioPaths.keyboardTap);
    });
  }

  @override
  void dispose() {
    disposeAudios();
    super.dispose();
  }

  Future<void> _playKeySound() async =>
      playPooledAudio(AudioKeyEnum.keyboardTap);

  @override
  Widget build(BuildContext context) => TextFormField(
    onTapOutside: (_) => widget.focusNode?.unfocus(),
    controller: widget.controller,
    focusNode: widget.focusNode,
    cursorHeight: 20,
    cursorOpacityAnimates: true,
    style: AppTextStyles.titleMedium().copyWith(height: 1),
    maxLength: 12,
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.name,
    textCapitalization: TextCapitalization.characters,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // não aceita espaços
    ],
    decoration: InputDecoration(
      hintText: '${context.loc.voterLabel.toUpperCase()} ${widget.index + 1}',
      hintStyle: AppTextStyles.titleLarge(
        color: AppColors.black.withAlpha(150),
      ),
    ),
    onChanged: (value) {
      _playKeySound();
      vibrate(10);
      widget.onChanged?.call(value);
    },
  );
}
