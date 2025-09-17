import 'package:secret_hitler_companion/core/objects/entities/fascist_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/liberal_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';

class GameSetup {
  GameSetup._();

  static int fascistCount(List<VoterEntity> setup) =>
      setup.whereType<FascistVoterEntity>().length;

  static int liberalCount(List<VoterEntity> setup) =>
      setup.whereType<LiberalVoterEntity>().length;

  static int get setupsCount => _config.length;

  static List<List<VoterEntity>> get gameSetups =>
      List.generate(6, (i) => getSetup(i + 5));

  static final Map<int, ({int liberals, int fascists, int hitler})> _config = {
    5: (liberals: 3, fascists: 1, hitler: 1),
    6: (liberals: 4, fascists: 1, hitler: 1),
    7: (liberals: 4, fascists: 2, hitler: 1),
    8: (liberals: 5, fascists: 2, hitler: 1),
    9: (liberals: 5, fascists: 3, hitler: 1),
    10: (liberals: 6, fascists: 3, hitler: 1),
  };

  static List<VoterEntity> getSetup(int playerCount) {
    final config = _config[playerCount];
    if (config == null) {
      throw Exception('Número de jogadores inválido: $playerCount');
    }

    final players = <VoterEntity>[];

    for (int i = 0; i < config.liberals; i++) {
      players.add(LiberalVoterEntity.empty());
    }

    for (int i = 0; i < config.fascists; i++) {
      players.add(FascistVoterEntity.empty());
    }

    for (int i = 0; i < config.hitler; i++) {
      players.add(FascistVoterEntity.empty(isHitler: true));
    }

    return players;
  }
}
