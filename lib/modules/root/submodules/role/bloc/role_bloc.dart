import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/utils/helpers/game_setup.dart';
import 'package:secret_hitler_companion/core/utils/stores/voter_store.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/bloc/role_state.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/envelope_interaction_state_enum.dart';

class RoleBloc extends Cubit<RoleState> {
  final VoterStore _voterStore;

  RoleBloc(this._voterStore) : super(RoleState.empty());

  Future<List<VoterEntity>> get storeVoters => _voterStore.voters;

  double get cardWidth => 70;
  double get cardHeight => 90;
  double get spacing => 20;
  double get targetZoom => 5;

  Future<void> setInitialData(
    AnimationController animationController,
    AnimationController burnController,
  ) async {
    await _loadPlayers();
    _setScaleAnimation(animationController);
    _setPerspectiveAnimation(animationController);
    _setInitialOffsetAnimation(animationController);
    _setBurnScaleAnimation(burnController);
    _setBurnRotationAnimation(burnController);
    _setBurnColorAnimation(burnController);
  }

  Future<void> _loadPlayers() async {
    final voters = await _voterStore.voters;
    final assignedVoters = GameSetup.assignRoles(voters);
    emit(state.copyWith(players: assignedVoters));
  }

  void toggleTearPreview() {
    emit(state.copyWith(showTearPreview: !state.showTearPreview));
  }

  void setFocusedIndex(int? index) {
    if (index == null) {
      emit(state.copyWith(clearFocusedIndex: true));
    } else {
      emit(state.copyWith(focusedIndex: index));
    }
  }

  void _setCurrentState(EnvelopeInteractionStateEnum newState) {
    emit(state.copyWith(currentState: newState));
  }

  void _setMatchVisible(bool visible) {
    emit(state.copyWith(matchVisible: visible));
  }

  void _setMatchOffset(Offset offset) {
    emit(state.copyWith(matchOffset: offset));
  }

  void setIsDragging(bool dragging) {
    emit(state.copyWith(isDragging: dragging));
  }

  void setDragStartPosition(Offset position) {
    emit(state.copyWith(dragStartPosition: position));
  }

  void setFireAnimationIndex(int? index) {
    if (index == null) {
      emit(state.copyWith(clearFireAnimationIndex: true));
    } else {
      emit(state.copyWith(fireAnimationIndex: index));
    }
  }

  void setCanGoBack(bool value) {
    emit(state.copyWith(canGoBack: value));
  }

  void addBurnedEnvelope(int index) {
    final newBurnedEnvelopes = Set<int>.from(state.burnedEnvelopes)..add(index);
    emit(state.copyWith(burnedEnvelopes: newBurnedEnvelopes));
  }

  void startMatchDrag(Offset localPosition) {
    if (state.currentState != EnvelopeInteractionStateEnum.waitingForMatch) {
      return;
    }

    emit(
      state.copyWith(
        isDragging: true,
        dragStartPosition: localPosition,
        currentState: EnvelopeInteractionStateEnum.draggingMatch,
      ),
    );
  }

  void updateMatchDrag(Offset localPosition) {
    if (state.currentState != EnvelopeInteractionStateEnum.draggingMatch) {
      return;
    }

    final newOffset = localPosition - state.dragStartPosition;
    emit(state.copyWith(matchOffset: newOffset));
  }

  void _setScaleAnimation(AnimationController animationController) => emit(
    state.copyWith(
      scaleAnimation: Tween<double>(begin: 1.0, end: targetZoom).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOutCubic,
        ),
      ),
    ),
  );

  void _setPerspectiveAnimation(AnimationController animationController) =>
      emit(
        state.copyWith(
          perspectiveAnimation: Tween<double>(begin: -0.4, end: 0.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOutCubic,
            ),
          ),
        ),
      );

  void _setInitialOffsetAnimation(AnimationController animationController) =>
      emit(
        state.copyWith(
          offsetAnimation: Tween<Offset>(
            begin: Offset.zero,
            end: Offset.zero,
          ).animate(animationController),
        ),
      );

  void _setOffsetAnimation(
    AnimationController animationController,
    Offset targetOffset,
  ) => emit(
    state.copyWith(
      offsetAnimation:
          Tween<Offset>(
            begin: state.offsetAnimation?.value ?? Offset.zero,
            end: targetOffset,
          ).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOutCubic,
            ),
          ),
    ),
  );

  void _setBurnScaleAnimation(AnimationController burnController) => emit(
    state.copyWith(
      burnScaleAnimation: TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 1.05,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 10,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.05,
            end: 0.75,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.75,
            end: 0.3,
          ).chain(CurveTween(curve: Curves.easeInQuart)),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.3,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.elasticOut)),
          weight: 30,
        ),
      ]).animate(burnController),
    ),
  );

  void _setBurnRotationAnimation(AnimationController burnController) => emit(
    state.copyWith(
      burnRotationAnimation: TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 0.02),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.02, end: -0.03),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -0.03, end: 0.01),
          weight: 30,
        ),
      ]).animate(burnController),
    ),
  );

  void _setBurnColorAnimation(AnimationController burnController) => emit(
    state.copyWith(
      burnColorAnimation: TweenSequence<Color?>([
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.white.withValues(alpha: 1.0),
            end: Color(0xFFD4A574).withValues(alpha: 0.9),
          ),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Color(0xFFD4A574).withValues(alpha: 0.9),
            end: Color(0xFF8B4513).withValues(alpha: 0.7),
          ),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Color(0xFF8B4513).withValues(alpha: 0.7),
            end: Color(0xFF1a1a1a).withValues(alpha: 0.3),
          ),
          weight: 50,
        ),
      ]).animate(burnController),
    ),
  );

  List<Offset> generateCardPositions(Size screenSize, int playersCount) {
    if (playersCount == 0) return [];

    final positions = <Offset>[];
    final cardsPerRow = (screenSize.width ~/ (cardWidth + spacing)).clamp(
      1,
      playersCount,
    );

    final int totalRows = (playersCount / cardsPerRow).ceil();
    final double gridWidth = (cardsPerRow * (cardWidth + spacing)) - spacing;
    final double gridHeight = (totalRows * (cardHeight + spacing)) - spacing;
    final Offset centerOffset = Offset(
      (screenSize.width - gridWidth) / 2,
      (screenSize.height - gridHeight) - 230,
    );

    for (int i = 0; i < playersCount; i++) {
      final int row = i ~/ cardsPerRow;
      final int col = i % cardsPerRow;

      final int itemsInThisRow = (row == totalRows - 1)
          ? playersCount - row * cardsPerRow
          : cardsPerRow;

      final double rowWidth =
          (itemsInThisRow * (cardWidth + spacing)) - spacing;
      final double rowOffsetX = (gridWidth - rowWidth) / 2;

      final double x = col * (cardWidth + spacing) + rowOffsetX;
      final double y = row * (cardHeight + spacing);

      positions.add(Offset(x, y));
    }

    return positions.map((pos) => pos + centerOffset).toList();
  }

  void focusOnCard(
    int index,
    Size screenSize,
    AnimationController animationController,
  ) {
    final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);
    final positions = generateCardPositions(screenSize, state.players.length);

    if (state.focusedIndex == index || state.burnedEnvelopes.contains(index)) {
      setFocusedIndex(null);
      _setCurrentState(EnvelopeInteractionStateEnum.selectingEnvelope);
      animationController.reverse();
    } else {
      final cardCenter = Offset(
        positions[index].dx + cardWidth / 2,
        positions[index].dy + (cardHeight / 2) - 10,
      );

      final targetOffset = Offset(
        screenCenter.dx / targetZoom - cardCenter.dx,
        screenCenter.dy / targetZoom - cardCenter.dy,
      );

      _setOffsetAnimation(animationController, targetOffset);

      setFocusedIndex(index);
      _setCurrentState(EnvelopeInteractionStateEnum.tearingEnvelope);

      animationController.forward(from: 0);
    }
  }

  void onEnvelopeShowCardComplete() {
    if (state.currentState == EnvelopeInteractionStateEnum.tearingEnvelope) {
      _setCurrentState(EnvelopeInteractionStateEnum.waitingForMatch);
      _setMatchVisible(true);
      _setMatchOffset(Offset(0, 70));

      Future.delayed(Duration(milliseconds: 300), () {
        _setMatchOffset(Offset.zero);
      });
    }
  }

  void onMatchPanEnd(
    DragEndDetails details,
    Size screenSize,
    AnimationController animationController,
    AnimationController burnController,
  ) {
    if (state.currentState != EnvelopeInteractionStateEnum.draggingMatch) {
      return;
    }

    final positions = generateCardPositions(screenSize, state.players.length);
    bool droppedOnFocusedEnvelope = false;

    if (state.focusedIndex != null) {
      final cardPosition = positions[state.focusedIndex!];
      final matchCurrentPosition = Offset(
        (positions[state.focusedIndex!].dx + cardWidth / 2) -
            1.5 +
            state.matchOffset.dx,
        positions[state.focusedIndex!].dy +
            cardHeight +
            10 +
            state.matchOffset.dy,
      );

      if (matchCurrentPosition.dx >= cardPosition.dx &&
          matchCurrentPosition.dx <= cardPosition.dx + cardWidth &&
          matchCurrentPosition.dy >= cardPosition.dy &&
          matchCurrentPosition.dy <= cardPosition.dy + cardHeight) {
        droppedOnFocusedEnvelope = true;
      }
    }

    setIsDragging(false);

    if (droppedOnFocusedEnvelope && state.focusedIndex != null) {
      _setCurrentState(EnvelopeInteractionStateEnum.showingFire);
      setFireAnimationIndex(state.focusedIndex);

      burnController.forward(from: 0);

      _setMatchOffset(Offset(0, 70));

      Future.delayed(const Duration(milliseconds: 500), () {
        _setMatchVisible(false);
      });

      Future.delayed(Duration(milliseconds: 1260), () {
        _setCurrentState(EnvelopeInteractionStateEnum.complete);
        addBurnedEnvelope(state.focusedIndex!);
      });

      Future.delayed(const Duration(milliseconds: 1800), () {
        focusOnCard(state.focusedIndex!, screenSize, animationController);
        setCanGoBack(true);
      });
    } else {
      _setMatchOffset(Offset.zero);
      _setCurrentState(EnvelopeInteractionStateEnum.waitingForMatch);
    }
  }
}
