import 'package:audioplayers/audioplayers.dart';

mixin AudioMixin {
  final Map<String, AudioPlayer> _players = {};
  final Map<String, AudioPool> _pools = {};
  final Map<String, Future<void> Function()?> _poolStops = {};

  String _prepareAudioPath(String path) =>
      path.startsWith('assets/') ? path.substring(7) : path;

  /// Para sons normais (com AudioPlayer)
  Future<void> playAudio(
    String key,
    String path, {
    PlayerMode mode = PlayerMode.lowLatency,
    double volume = 1.0,
  }) async {
    var player = _players[key];
    if (player == null) {
      player = AudioPlayer();
      _players[key] = player;
    }

    await player.stop();
    await player.setVolume(volume);
    await player.play(AssetSource(_prepareAudioPath(path)), mode: mode);
  }

  /// Para sons curtos/repetitivos (com AudioPool)
  Future<void> playPooledAudio(
    String key,
    String path, {
    int maxPlayers = 3,
    double volume = 1.0,
  }) async {
    var pool = _pools[key];
    if (pool == null) {
      pool = await AudioPool.create(
        source: AssetSource(_prepareAudioPath(path)),
        maxPlayers: maxPlayers,
      );
      _pools[key] = pool;
    }

    final stopFn = await pool.start(volume: volume);
    _poolStops[key] = stopFn;
  }

  /// Para parar um som normal (AudioPlayer)
  Future<void> stopAudio(String key) async {
    final player = _players[key];
    if (player != null) {
      await player.stop();
    }
  }

  /// Para parar um som em pool
  Future<void> stopPooledAudio(String key) async {
    final stopFn = _poolStops[key];
    if (stopFn != null) {
      await stopFn();
      _poolStops.remove(key);
    }
  }

  /// Libera tudo
  Future<void> disposeAudios() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _players.clear();
    _pools.clear();
    _poolStops.clear();
  }
}
