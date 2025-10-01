class VoterEntity {
  final String name;
  final String cardImage;

  VoterEntity({required this.name, required this.cardImage});

  factory VoterEntity.empty() => VoterEntity(name: '', cardImage: '');

  Map<String, dynamic> toMap() => {'name': name, 'cardImage': cardImage};

  factory VoterEntity.fromMap(Map<String, dynamic> map) =>
      VoterEntity(name: map['name'] ?? '', cardImage: map['cardImage'] ?? '');

  VoterEntity copyWith({String? name, String? cardImage}) => VoterEntity(
    name: name ?? this.name,
    cardImage: cardImage ?? this.cardImage,
  );
}
