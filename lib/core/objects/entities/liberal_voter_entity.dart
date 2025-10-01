import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class LiberalVoterEntity extends VoterEntity {
  LiberalVoterEntity({required super.cardImage, required super.name});

  @override
  factory LiberalVoterEntity.empty() =>
      LiberalVoterEntity(name: '', cardImage: '');

  @override
  String toString() => 'LiberalVoterEntity(name: $name)';
}
