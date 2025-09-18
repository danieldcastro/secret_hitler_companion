import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/helpers/game_setup.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_controller.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/skull_button.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/paper_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/views/widgets/disc_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/views/widgets/quantity_book_widget.dart';

class QuantityPage extends StatefulWidget {
  const QuantityPage({super.key});

  @override
  State<QuantityPage> createState() => _QuantityPageState();
}

class _QuantityPageState extends State<QuantityPage> {
  final int _numberAfterDrag = 5; // valor inicial

  final controller = BookController(initialPage: 1);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PaperWidget(
            title: context.loc.voterQuantityPageTitle,
            height: 120,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 40),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox.square(
                dimension: 310 * 0.7,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Transform.scale(
                    scale: 0.9,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: -60,
                          top: 40,
                          child: Image.asset(
                            ImagePaths.phoneCable,
                            height: 300,
                          ),
                        ),
                        Positioned(
                          top: -70,
                          child: Image.asset(
                            ImagePaths.phoneHandset,
                            width: 400,
                          ),
                        ),
                        DiscWidget(
                          initialNumber: _numberAfterDrag,
                          numbers: List.generate(
                            GameSetup.setupsCount,
                            (i) => 5 + i,
                          ).reversed.toList(),
                          onNumberSelected: (value) {
                            controller.goToPage(value - 4);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: FittedBox(
              child: SizedBox(
                width: 350,
                height: 100,
                child: QuantityBookWidget(controller: controller),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: FittedBox(child: SkullButton(onPressed: () {})),
          ),
        ],
      ),
    ),
  );
}
