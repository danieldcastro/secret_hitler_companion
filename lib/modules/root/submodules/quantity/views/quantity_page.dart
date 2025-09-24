import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/helpers/game_setup.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/book/book_controller.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/paper_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/bloc/quantity_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/views/widgets/disc_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/quantity/views/widgets/quantity_book_widget.dart';

class QuantityPage extends StatefulWidget {
  final QuantityBloc bloc;
  const QuantityPage({required this.bloc, super.key});

  @override
  State<QuantityPage> createState() => _QuantityPageState();
}

class _QuantityPageState extends State<QuantityPage> {
  int _quantity = 5;
  bool _loading = true;

  final controller = BookController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final quantity = await widget.bloc.storeQuantity;
    if (mounted) {
      setState(() {
        _quantity = quantity;
        _loading = false;
        controller.goToPage(quantity - 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
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
                  maxWidth: double.maxFinite,
                  maxHeight: double.maxFinite,
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
                        if (!_loading)
                          DiscWidget(
                            initialNumber: _quantity,
                            numbers: List.generate(
                              GameSetup.setupsCount,
                              (i) => 5 + i,
                            ).reversed.toList(),
                            onNumberSelected: (value) {
                              controller.goToPage(value - 4);
                              setState(() => _quantity = value);
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
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FittedBox(
              child: SizedBox(
                width: 350,
                height: 100,
                child: QuantityBookWidget(controller: controller),
              ),
            ),
          ),
          FooterWidget(
            onTap: () =>
                widget.bloc.handleSubmit(GameSetup.getSetup(_quantity)),
          ),
        ],
      ),
    ),
  );
}
