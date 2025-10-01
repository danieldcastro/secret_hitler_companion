// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get holdButtonMessage => 'Tap and hold to start the assembly';

  @override
  String get voterQuantityPageTitle => 'Dial the number of voters';

  @override
  String get voterLabel => 'Voter';

  @override
  String get fascistLabel => 'Fascist';

  @override
  String get liberalLabel => 'Liberal';

  @override
  String get liberalsLabel => 'Liberals';

  @override
  String get hitlerLabel => 'Hitler';

  @override
  String get backLabel => 'Back';

  @override
  String get rosterPageMessage => 'Register all voters to continue';

  @override
  String get confidentialLabel => 'Confidential';

  @override
  String get topSecretLabel => 'Top Secret';

  @override
  String get rolePageMessage => 'Check your roles to start the voting';

  @override
  String envelopeMessage(String playerName) {
    return 'Only the voter identified as $playerName should open this envelope.';
  }

  @override
  String get roleCardMessage => 'Your secret role';
}
