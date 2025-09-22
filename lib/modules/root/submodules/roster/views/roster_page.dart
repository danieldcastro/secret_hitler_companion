import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fy/utils/fy_sizes.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/buttons/skull_button.dart';
import 'package:secret_hitler_companion/core/utils/widgets/images/paper_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/views/widgets/roster_text_field.dart';

class RosterPage extends StatefulWidget {
  final RosterBloc bloc;
  const RosterPage({required this.bloc, super.key});

  @override
  State<RosterPage> createState() => _RosterPageState();
}

class _RosterPageState extends State<RosterPage> {
  static const double _paperWidth = 190;
  static const double _defaultPaperHeight = 32;

  double _calculatePaperHeight(int votersCount) {
    final height = _defaultPaperHeight * (votersCount + 1);
    final maxHeight = FySizes.height(context) - 300;
    return height.clamp(0, maxHeight);
  }

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    widget.bloc.getRootVoters();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<String> names) {
    for (int i = 0; i < names.length; i++) {
      _controllers.add(TextEditingController());
    }

    for (int i = 0; i < names.length; i++) {
      final controller = _controllers[i];
      if (controller.text != names[i]) {
        controller.value = TextEditingValue(text: names[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    onBack: () => Globals.nav.navigate(NestedRoutes.quantity),
    body: BlocBuilder<RosterBloc, RosterState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final names = state.voters.map((voter) => voter.name).toList();
        final paperHeight = _calculatePaperHeight(names.length);
        final allNamesFilled = names.every((name) => name.trim().isNotEmpty);

        _syncControllers(names);

        return Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.expand,
                children: [
                  _buildBackgroundPaperContainer(paperHeight),
                  _buildTypewriterImage(),
                  _buildPaperContainer(names, paperHeight),
                ],
              ),
            ),
            Divider(color: Color(0xffC9532B), thickness: 3, height: 0),
            Divider(
              color: Color(0xffC9532B).withAlpha(100),
              thickness: 10,
              height: 10,
            ),
            Divider(color: AppColors.black, thickness: 5, height: 5),
            Container(
              color: Color(0xffC9532B).withAlpha(100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedSlide(
                    offset: allNamesFilled ? Offset.zero : Offset(0, 1),
                    curve: Curves.elasticInOut,
                    duration: const Duration(milliseconds: 2000),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: SkullButton(onPressed: () {}),
                    ),
                  ),

                  AnimatedSlide(
                    offset: allNamesFilled ? Offset(0, 1) : Offset.zero,
                    curve: Curves.elasticInOut,
                    duration: const Duration(milliseconds: 2000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: PaperWidget(
                        title: 'Registre todos os votantes para continuar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _buildTypewriterImage() => Positioned(
    bottom: -2,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Image.asset(ImagePaths.table, fit: BoxFit.fill),
      ),
    ),
  );

  Widget _buildBackgroundPaperContainer(double paperHeight) => Positioned(
    bottom: 136,
    child: Transform.rotate(
      angle: -0.01,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _paperWidth,
        height: paperHeight,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ),
  );

  Widget _buildPaperContainer(List<String> names, double paperHeight) =>
      Positioned(
        bottom: 140,
        child: Transform.rotate(
          angle: -0.01,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _paperWidth - 8,
            height: paperHeight - 8,
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(
                      color: AppColors.black.withAlpha(100),
                      thickness: 1,
                      height: 0,
                    ),
                    const SizedBox(height: 15),
                    ...names.mapIndexed(
                      (index, name) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: RosterTextField(
                          key: ValueKey('voter_$index'),
                          controller: _controllers[index],
                          onChanged: (name) =>
                              widget.bloc.updateVoterName(index, name),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
