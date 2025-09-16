import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class FascistVoterEntity extends VoterEntity {
  final bool isHitler;
  FascistVoterEntity({required super.name, required this.isHitler});
}
