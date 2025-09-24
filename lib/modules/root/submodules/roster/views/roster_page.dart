import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fy/utils/fy_sizes.dart';
import 'package:secret_hitler_companion/core/objects/enums/audio_key_enum.dart';
import 'package:secret_hitler_companion/core/routes/app_routes.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/audio_paths.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/core/utils/extensions/context_extensions.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';
import 'package:secret_hitler_companion/core/utils/mixins/audio_mixin.dart';
import 'package:secret_hitler_companion/core/utils/widgets/app_scaffold.dart';
import 'package:secret_hitler_companion/core/utils/widgets/footer_widget.dart';
import 'package:secret_hitler_companion/core/utils/widgets/table_edge_widget.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/views/widgets/roster_text_field.dart';

class RosterPage extends StatefulWidget {
  final RosterBloc bloc;
  const RosterPage({required this.bloc, super.key});

  @override
  State<RosterPage> createState() => _RosterPageState();
}

class _RosterPageState extends State<RosterPage> with AudioMixin {
  static const double _paperWidth = 190;
  static const double _defaultPaperHeight = 36;

  double _calculatePaperHeight(int votersCount) {
    final height = _defaultPaperHeight * (votersCount + 1);
    final maxHeight = FySizes.height(context) - 400;
    return height.clamp(0, maxHeight);
  }

  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    widget.bloc.getStoreVoters();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<String> names) {
    if (_controllers.isEmpty) {
      for (int i = 0; i < names.length; i++) {
        _controllers.add(TextEditingController());
        _focusNodes.add(FocusNode());
      }

      for (int i = 0; i < names.length; i++) {
        final controller = _controllers[i];
        if (controller.text != names[i]) {
          controller.value = TextEditingValue(text: names[i]);
        }
      }
    }
  }

  Future<void> _playBellSound() async =>
      playAudio(AudioKeyEnum.bell, AudioPaths.bell);

  void _onTapTypewriter() {
    if (_focusNodes.any((node) => node.hasFocus)) {
      _focusNodes.firstWhere((node) => node.hasFocus).unfocus();
      return;
    }
    _playBellSound();
    final firstControllerEmpty = _controllers.firstWhereOrNull(
      (c) => c.text.isEmpty,
    );
    final indexOfController = _controllers.indexOf(
      firstControllerEmpty ?? _controllers.last,
    );
    if (indexOfController != -1) {
      _focusNodes[indexOfController].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    showBackButton: true,
    onBack: () => Globals.nav.navigate(NestedRoutes.quantity),
    body: BlocBuilder<RosterBloc, RosterState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final names = state.voters.map((voter) => voter.name).toList();
        final paperHeight = _calculatePaperHeight(names.length);
        final isAllNamesFilled = names.every((name) => name.trim().isNotEmpty);

        _syncControllers(names);

        return Column(
          children: [
            Expanded(
              child: TapRegion(
                onTapOutside: (event) => _focusNodes
                    .firstWhereOrNull((node) => node.hasFocus)
                    ?.unfocus(),
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
            ),
            TableEdgeWidget(),
            FooterWidget(
              showButton: isAllNamesFilled,
              onTap: widget.bloc.handleSubmit,
              backgroundColor: AppColors.darkPropRed,
              message: context.loc.rosterPageMessage,
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onTapTypewriter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Image.asset(ImagePaths.table, fit: BoxFit.fill),
          ),
        ),
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
                          isLast: index == names.length - 1,
                          key: ValueKey('voter_$index'),
                          focusNode: _focusNodes[index],
                          index: index,
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
