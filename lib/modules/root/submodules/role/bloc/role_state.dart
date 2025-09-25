class RoleState {
  final bool showTearPreview;
  const RoleState({required this.showTearPreview});

  factory RoleState.empty() => RoleState(showTearPreview: false);
}
