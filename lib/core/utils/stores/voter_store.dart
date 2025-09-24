import 'dart:convert';

import 'package:secret_hitler_companion/core/objects/entities/voter_entity.dart';
import 'package:secret_hitler_companion/core/objects/enums/storage_key_enum.dart';
import 'package:secret_hitler_companion/core/utils/helpers/globals.dart';

class VoterStore {
  VoterStore();

  Future<List<VoterEntity>> get voters => getVoters();

  Future<List<VoterEntity>> getVoters() async {
    final votersJson = await Globals.storage.readData<String>(
      StorageKeyEnum.voters,
    );

    if (votersJson == null) return [];
    final List decoded = jsonDecode(votersJson);
    return decoded.map((e) => VoterEntity.fromMap(e)).toList();
  }

  void updateVoters(List<VoterEntity> voters) {
    final jsonList = voters.map((voter) => voter.toMap()).toList();
    Globals.storage.writeData(
      StorageKeyEnum.voters,
      value: jsonEncode(jsonList),
    );
  }
}
