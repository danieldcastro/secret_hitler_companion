import 'package:audioplayers/audioplayers.dart';
import 'package:secret_hitler_companion/core/objects/enums/audio_key_enum.dart';

mixin AudioMixin {
  final Map<AudioKeyEnum, AudioPlayer> _players = {};
  final Map<AudioKeyEnum, PlayerState> _playerStates = {};

  final Map<AudioKeyEnum, AudioPool> _pools = {};
  final Map<AudioKeyEnum, Future<void> Function()> _poolStops = {};

  /// Prepara caminho de asset
  String _prepareAudioPath(String path) =>
      path.startsWith('assets/') ? path.substring(7) : path;

  // =====================
  // AudioPlayer (normal)
  // =====================
  Future<void> playAudio(
    AudioKeyEnum key,
    String path, {
    PlayerMode mode = PlayerMode.lowLatency,
    double volume = 1.0,
    bool loop = false,
    bool preventIfPlaying = false,
  }) async {
    var player = _players[key];
    if (player == null) {
      player = AudioPlayer();
      _players[key] = player;
      player.onPlayerStateChanged.listen((state) {
        _playerStates[key] = state;
      });
    }

    if (preventIfPlaying && _playerStates[key] == PlayerState.playing) return;

    await player.stop();
    await player.setVolume(volume);
    await player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
    await player.play(AssetSource(_prepareAudioPath(path)), mode: mode);
  }

  Future<void> stopAudio(AudioKeyEnum key) async {
    final player = _players[key];
    if (player != null) {
      try {
        await player.stop();
        _playerStates[key] = PlayerState.stopped;
      } catch (_) {}
    }
  }

  // =====================
  // AudioPool (curtos/repetitivos)
  // =====================
  /// Pré-carrega o pool (melhor fazer no initState)
  Future<void> createPool(
    AudioKeyEnum key,
    String path, {
    int maxPlayers = 3,
  }) async {
    if (_pools.containsKey(key)) return;
    final pool = await AudioPool.create(
      source: AssetSource(_prepareAudioPath(path)),
      maxPlayers: maxPlayers,
    );
    _pools[key] = pool;
  }

  /// Toca o áudio do pool (pode ser chamado várias vezes rapidamente)
  Future<void> playPooledAudio(AudioKeyEnum key, {double volume = 1.0}) async {
    final pool = _pools[key];
    if (pool == null) return;

    final stopFn = await pool.start(volume: volume);

    // Substitui qualquer stopFn anterior (automático)
    _poolStops[key] = () async {
      await stopFn();
      if (_poolStops[key] == stopFn) {
        _poolStops.remove(key);
      }
    };
  }

  /// Para manualmente
  Future<void> stopPooledAudio(AudioKeyEnum key) async {
    final stopFn = _poolStops[key];
    if (stopFn != null) {
      await stopFn();
    }
  }

  // =====================
  // Dispose tudo
  // =====================
  Future<void> disposeAudios() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _players.clear();
    _playerStates.clear();
    _pools.clear();
    _poolStops.clear();
  }
}
