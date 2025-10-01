import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/modules/root/submodules/role/views/widgets/utils/envelope_interaction_state_enum.dart';

class RoleState {
  final bool showTearPreview;
  final List<VoterEntity> players;
  final int? focusedIndex;
  final Set<int> burnedEnvelopes;
  final EnvelopeInteractionStateEnum currentState;
  final bool matchVisible;
  final Offset matchOffset;
  final bool isDragging;
  final Offset dragStartPosition;
  final int? fireAnimationIndex;
  final bool canGoBack;
  final Animation<double>? burnScaleAnimation;
  final Animation<double>? burnRotationAnimation;
  final Animation<Color?>? burnColorAnimation;
  final Animation<double>? scaleAnimation;
  final Animation<double>? perspectiveAnimation;
  final Animation<Offset>? offsetAnimation;

  const RoleState({
    required this.showTearPreview,
    required this.players,
    required this.focusedIndex,
    required this.burnedEnvelopes,
    required this.currentState,
    required this.matchVisible,
    required this.matchOffset,
    required this.isDragging,
    required this.dragStartPosition,
    required this.fireAnimationIndex,
    required this.canGoBack,
    required this.burnScaleAnimation,
    required this.burnRotationAnimation,
    required this.burnColorAnimation,
    required this.scaleAnimation,
    required this.perspectiveAnimation,
    required this.offsetAnimation,
  });

  factory RoleState.empty() => RoleState(
    showTearPreview: false,
    players: [],
    focusedIndex: null,
    burnedEnvelopes: {},
    currentState: EnvelopeInteractionStateEnum.selectingEnvelope,
    matchVisible: false,
    matchOffset: Offset.zero,
    isDragging: false,
    dragStartPosition: Offset.zero,
    fireAnimationIndex: null,
    canGoBack: true,
    burnScaleAnimation: null,
    burnRotationAnimation: null,
    burnColorAnimation: null,
    scaleAnimation: null,
    perspectiveAnimation: null,
    offsetAnimation: null,
  );

  bool get allEnvelopesBurned => burnedEnvelopes.length == players.length;
  bool get hasPlayers => players.isNotEmpty;

  RoleState copyWith({
    bool? showTearPreview,
    List<VoterEntity>? players,
    int? focusedIndex,
    bool clearFocusedIndex = false,
    Set<int>? burnedEnvelopes,
    EnvelopeInteractionStateEnum? currentState,
    bool? matchVisible,
    Offset? matchOffset,
    bool? isDragging,
    Offset? dragStartPosition,
    int? fireAnimationIndex,
    bool clearFireAnimationIndex = false,
    bool? canGoBack,
    Animation<double>? burnScaleAnimation,
    Animation<double>? burnRotationAnimation,
    Animation<Color?>? burnColorAnimation,
    Animation<double>? scaleAnimation,
    Animation<double>? perspectiveAnimation,
    Animation<Offset>? offsetAnimation,
  }) => RoleState(
    showTearPreview: showTearPreview ?? this.showTearPreview,
    players: players ?? this.players,
    focusedIndex: clearFocusedIndex
        ? null
        : (focusedIndex ?? this.focusedIndex),
    burnedEnvelopes: burnedEnvelopes ?? this.burnedEnvelopes,
    currentState: currentState ?? this.currentState,
    matchVisible: matchVisible ?? this.matchVisible,
    matchOffset: matchOffset ?? this.matchOffset,
    isDragging: isDragging ?? this.isDragging,
    dragStartPosition: dragStartPosition ?? this.dragStartPosition,
    fireAnimationIndex: clearFireAnimationIndex
        ? null
        : (fireAnimationIndex ?? this.fireAnimationIndex),
    canGoBack: canGoBack ?? this.canGoBack,
    burnScaleAnimation: burnScaleAnimation ?? this.burnScaleAnimation,
    burnRotationAnimation: burnRotationAnimation ?? this.burnRotationAnimation,
    burnColorAnimation: burnColorAnimation ?? this.burnColorAnimation,
    scaleAnimation: scaleAnimation ?? this.scaleAnimation,
    perspectiveAnimation: perspectiveAnimation ?? this.perspectiveAnimation,
    offsetAnimation: offsetAnimation ?? this.offsetAnimation,
  );
}
