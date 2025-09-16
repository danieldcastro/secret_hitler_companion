import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/widgets/paper_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/views/widgets/disc_widget.dart';

class QuantityPage extends StatefulWidget {
  const QuantityPage({super.key});

  @override
  State<QuantityPage> createState() => _QuantityPageState();
}

class _QuantityPageState extends State<QuantityPage> {
  int _numberAfterDrag = 5; // valor inicial

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaperWidget(
            title: context.loc.voterQuantityPageTitle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 40),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DiscWidget(
                initialNumber: _numberAfterDrag,
                numbers: List.generate(6, (i) => 5 + i), // 5 a 10
                onNumberSelected: (value) {
                  setState(() {
                    _numberAfterDrag = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          PaperWidget(
            title: '$_numberAfterDrag',
            contentPadding: const EdgeInsets.all(20),
          ),
        ],
      ),
    ),
  );
}
