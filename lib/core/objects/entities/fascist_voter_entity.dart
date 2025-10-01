import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class FascistVoterEntity extends VoterEntity {
  final bool isHitler;
  FascistVoterEntity({
    required super.name,
    required super.cardImage,
    required this.isHitler,
  });

  @override
  Map<String, dynamic> toMap() => {'name': name, 'isHitler': isHitler};

  factory FascistVoterEntity.fromMap(Map<String, dynamic> map) =>
      FascistVoterEntity(
        name: map['name'] ?? '',
        isHitler: map['isHitler'] ?? false,
        cardImage: map['cardImage'] ?? '',
      );

  factory FascistVoterEntity.empty({bool isHitler = false}) =>
      FascistVoterEntity(name: '', isHitler: isHitler, cardImage: '');

  @override
  String toString() => 'FascistVoterEntity(name: $name, isHitler: $isHitler)';
}
