// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get holdButtonMessage => 'Toque e segure para iniciar a assembleia';

  @override
  String get voterQuantityPageTitle => 'Disque o número de votantes';

  @override
  String get voterLabel => 'Votante';

  @override
  String get fascistLabel => 'Fascista';

  @override
  String get liberalLabel => 'Liberal';

  @override
  String get liberalsLabel => 'Liberais';

  @override
  String get hitlerLabel => 'Hitler';

  @override
  String get backLabel => 'Voltar';

  @override
  String get rosterPageMessage => 'Registre todos os votantes para continuar';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class SPtBr extends SPt {
  SPtBr() : super('pt_BR');

  @override
  String get holdButtonMessage => 'Toque e segure para iniciar a assembleia';

  @override
  String get voterQuantityPageTitle => 'Disque o número de votantes';

  @override
  String get voterLabel => 'Votante';

  @override
  String get fascistLabel => 'Fascista';

  @override
  String get liberalLabel => 'Liberal';

  @override
  String get liberalsLabel => 'Liberais';

  @override
  String get hitlerLabel => 'Hitler';

  @override
  String get backLabel => 'Voltar';

  @override
  String get rosterPageMessage => 'Registre todos os votantes para continuar';
}
