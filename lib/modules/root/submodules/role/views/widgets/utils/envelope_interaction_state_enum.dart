enum EnvelopeInteractionStateEnum {
  selectingEnvelope,
  tearingEnvelope,
  waitingForMatch,
  draggingMatch,
  showingFire,
  complete;

  bool get canBack => [selectingEnvelope, complete].contains(this);
}
