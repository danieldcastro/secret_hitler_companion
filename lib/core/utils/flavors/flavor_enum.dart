enum FlavorEnum {
  prod,
  qa;

  static FlavorEnum fromString(String? value) => FlavorEnum.values.firstWhere(
    (e) => e.name == value,
    orElse: () => FlavorEnum.prod,
  );

  String get appTitle => switch (this) {
    qa => '[QA] Secret Hitler Companion',
    prod => 'Secret Hitler Companion',
  };

  bool get isQa => this == FlavorEnum.qa;
}
