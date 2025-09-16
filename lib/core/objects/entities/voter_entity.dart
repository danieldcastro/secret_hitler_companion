class VoterEntity {
  final String name;

  VoterEntity({required this.name});

  VoterEntity copyWith({String? name}) => VoterEntity(name: name ?? this.name);
}
