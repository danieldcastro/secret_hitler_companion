import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/themes/app_colors.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_bloc.dart';
import 'package:secret_hitler_companion/modules/root/bloc/root_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/bloc/roster_bloc.dart';
import 'package:secret_hitler_companion/modules/root/submodules/roster/views/widgets/roster_text_field.dart';

class RosterPage extends StatefulWidget {
  final RosterBloc rosterBloc;
  const RosterPage({required this.rosterBloc, super.key});

  @override
  State<RosterPage> createState() => _RosterPageState();
}

class _RosterPageState extends State<RosterPage> {
  static const double _paperWidth = 300;
  static const double _defaultPaperHeight = 40;

  double _calculatePaperHeight(int votersCount) =>
      (_defaultPaperHeight * (votersCount + 1)) + 40;

  RootBloc get _rootBloc => widget.rosterBloc.rootBloc;

  final List<TextEditingController> _controllers = [];
  final TextEditingController _newVoterController = TextEditingController();
  final FocusNode _newVoterFocusNode = FocusNode();
  int _previousVoterCount = 0;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _newVoterController.dispose();
    _newVoterFocusNode.dispose();
    super.dispose();
  }

  void _syncControllers(List<String> names) {
    final diff = names.length - _controllers.length;

    if (diff > 0) {
      for (int i = 0; i < diff; i++) {
        _controllers.add(TextEditingController());
      }
    } else if (diff < 0) {
      for (int i = 0; i < -diff; i++) {
        _controllers.removeLast().dispose();
      }
    }

    for (int i = 0; i < names.length; i++) {
      final controller = _controllers[i];
      if (controller.text != names[i]) {
        controller.value = TextEditingValue(
          text: names[i],
          selection: TextSelection.fromPosition(
            TextPosition(offset: names[i].length),
          ),
        );
      }
    }

    if (names.length > _previousVoterCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _newVoterFocusNode.requestFocus();
      });
    }
    _previousVoterCount = names.length;
  }

  void _addVoter(String name) {
    if (name.trim().isNotEmpty) {
      _rootBloc.addVoterByName(name);
      _newVoterController.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocBuilder<RootBloc, RootState>(
      bloc: _rootBloc,
      builder: (context, rootState) {
        final names = rootState.voters.map((voter) => voter.name).toList();
        final paperHeight = _calculatePaperHeight(names.length);

        _syncControllers(names);

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildBackgroundPaperContainer(paperHeight),
            _buildTypewriterImage(),
            _buildPaperContainer(names, paperHeight),
          ],
        );
      },
    ),
  );

  Widget _buildTypewriterImage() => Positioned(
    top: -90,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Transform.rotate(
          angle: 180 * 3.14 / 180,
          child: Image.asset(ImagePaths.typewriter),
        ),
      ),
    ),
  );

  Widget _buildBackgroundPaperContainer(double paperHeight) => Positioned(
    top: 110,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _paperWidth,
      height: paperHeight,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  Widget _buildPaperContainer(List<String> names, double paperHeight) =>
      Positioned(
        top: 114,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _paperWidth - 8,
          height: paperHeight - 8,
          decoration: BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  ...names.mapIndexed(
                    (index, name) => RosterTextField(
                      key: ValueKey('voter_$index'),
                      controller: _controllers[index],
                      onChanged: (name) =>
                          _rootBloc.updateVoterName(index, name),
                    ),
                  ),
                  RosterTextField(
                    controller: _newVoterController,
                    focusNode: _newVoterFocusNode,
                    onChanged: _addVoter,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
