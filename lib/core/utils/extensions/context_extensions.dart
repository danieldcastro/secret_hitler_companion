import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/l10n/arb/s.dart';

extension ContextExtensions on BuildContext {
  S get loc => S.of(this);
}
