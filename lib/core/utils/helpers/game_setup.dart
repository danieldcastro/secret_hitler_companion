import 'dart:math';

import 'package:secret_hitler_companion/core/objects/entities/fascist_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/liberal_voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

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

    return [
      ...List.generate(config.liberals, (_) => LiberalVoterEntity.empty()),
      ...List.generate(config.fascists, (_) => FascistVoterEntity.empty()),
      ...List.generate(
        config.hitler,
        (_) => FascistVoterEntity.empty(isHitler: true),
      ),
    ];
  }

  static List<VoterEntity> assignRoles(List<VoterEntity> players) {
    final playerCount = players.length;

    final fascistCards = [
      ImagePaths.fascist1Card,
      ImagePaths.fascist2Card,
      ImagePaths.fascist3Card,
      ImagePaths.fascist4Card,
    ]..shuffle(Random());

    final liberalCards = [
      ImagePaths.liberal1Card,
      ImagePaths.liberal2Card,
      ImagePaths.liberal3Card,
      ImagePaths.liberal4Card,
      ImagePaths.liberal5Card,
      ImagePaths.liberal6Card,
    ]..shuffle(Random());

    final config = _config[playerCount];
    if (config == null) {
      throw ArgumentError('Número de jogadores inválido: $playerCount');
    }

    final indices = List<int>.generate(playerCount, (i) => i)
      ..shuffle(Random());
    final hitlers = indices.take(config.hitler).toSet();
    final fascists = indices.skip(config.hitler).take(config.fascists).toSet();

    int fascistIndex = 0;
    int liberalIndex = 0;

    return List<VoterEntity>.generate(playerCount, (i) {
      final player = players[i];

      if (hitlers.contains(i)) {
        return FascistVoterEntity(
          name: player.name,
          isHitler: true,
          cardImage: ImagePaths.hitlerCard,
        );
      }
      if (fascists.contains(i)) {
        final card = fascistCards[fascistIndex % fascistCards.length];
        fascistIndex++;
        return FascistVoterEntity(
          name: player.name,
          isHitler: false,
          cardImage: card,
        );
      }

      final card = liberalCards[liberalIndex % liberalCards.length];
      liberalIndex++;
      return LiberalVoterEntity(name: player.name, cardImage: card);
    });
  }
}
