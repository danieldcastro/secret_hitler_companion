import 'package:vibration/vibration.dart';

mixin VibratorMixin {
  Future<void> cancelVibration() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.cancel();
    }
  }

  Future<void> vibrate(int milliseconds) async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: milliseconds);
    }
  }
}
