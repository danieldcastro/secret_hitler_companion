import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class RootState {
  final List<VoterEntity> voters;
  RootState({required this.voters});

  factory RootState.empty() => RootState(voters: []);

  RootState copyWith({List<VoterEntity>? voters}) =>
      RootState(voters: voters ?? this.voters);
}
