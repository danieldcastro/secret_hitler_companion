import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class FascistVoterEntity extends VoterEntity {
  final bool isHitler;
  FascistVoterEntity({required super.name, required this.isHitler});

  @override
  Map<String, dynamic> toMap() => {'name': name, 'isHitler': isHitler};

  factory FascistVoterEntity.fromMap(Map<String, dynamic> map) =>
      FascistVoterEntity(
        name: map['name'] ?? '',
        isHitler: map['isHitler'] ?? false,
      );

  factory FascistVoterEntity.empty({bool isHitler = false}) =>
      FascistVoterEntity(name: '', isHitler: isHitler);
}
