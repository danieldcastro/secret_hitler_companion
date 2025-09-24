import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/push_back_button.dart';

class AppScaffold extends StatefulWidget {
  final VoidCallback? onBack;
  final bool showBackButton;
  final Widget body;
  const AppScaffold({
    required this.body,
    this.onBack,
    this.showBackButton = false,
    super.key,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool _isPopping = false;

  void _handlePop() {
    if (_isPopping) return;
    _isPopping = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onBack != null) {
        widget.onBack!();
      } else {
        Globals.nav.pop();
      }
      _isPopping = false;
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (didPop) return;
      _handlePop();
    },
    child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: widget.showBackButton
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: PushBackButton(onPressed: _handlePop),
              ),
            )
          : null,
      body: widget.body,
    ),
  );
}
