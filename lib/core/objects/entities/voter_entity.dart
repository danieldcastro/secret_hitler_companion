class VoterEntity {
  final String name;

  VoterEntity({required this.name});

  factory VoterEntity.empty() => VoterEntity(name: '');

  Map<String, dynamic> toMap() => {'name': name};

  factory VoterEntity.fromMap(Map<String, dynamic> map) =>
      VoterEntity(name: map['name'] ?? '');

  VoterEntity copyWith({String? name}) => VoterEntity(name: name ?? this.name);
}
