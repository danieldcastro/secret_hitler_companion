import 'package:audioplayers/audioplayers.dart';

mixin AudioMixin {
  String _prepareAudioPath(String path) =>
      path.startsWith('assets/') ? path.substring(7) : path;

  Future<void> playAudio(
    AudioPlayer player,
    String path, {
    PlayerMode mode = PlayerMode.lowLatency,
    double volume = 1.0,
  }) async {
    await player.play(
      AssetSource(_prepareAudioPath(path)),
      mode: mode,
      volume: volume,
    );
  }
}
