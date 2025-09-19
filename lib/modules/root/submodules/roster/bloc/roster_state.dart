import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class RosterState {
  final List<VoterEntity> voters;
  RosterState({required this.voters});

  factory RosterState.empty() => RosterState(voters: []);

  RosterState copyWith({List<VoterEntity>? voters}) =>
      RosterState(voters: voters ?? this.voters);
}
