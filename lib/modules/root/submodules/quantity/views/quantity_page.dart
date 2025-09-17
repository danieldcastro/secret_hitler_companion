import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
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
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: -60,
                    top: 40,
                    child: Image.asset(ImagePaths.phoneCable, height: 300),
                  ),
                  Positioned(
                    top: -70,
                    child: Image.asset(ImagePaths.phoneHandset, width: 400),
                  ),
                  DiscWidget(
                    initialNumber: _numberAfterDrag,
                    numbers: List.generate(
                      6,
                      (i) => 5 + i,
                    ).reversed.toList(), // 5 a 10
                    onNumberSelected: (value) {
                      setState(() {
                        _numberAfterDrag = value;
                      });
                    },
                  ),
                ],
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
