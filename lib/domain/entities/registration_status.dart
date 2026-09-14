/// Identificador do status juridico do registro de candidatura no TSE.
///
/// Conforme resolucoes normativas do Tribunal Superior Eleitoral, o status
/// determina a aptidao juridica para recepcao de votos validos nas urnas
/// eletronicas (art. 16-A da Lei n. 9.504/1997).
enum RegistrationStatus {
  deferred,
  deferredWithAppeal,
  waitingJudgment,
  ineligible,
  ineligibleWithAppeal,
  cancelled,
  renunciation,
  deceased,
  revoked,
  substituted,
  unprocessed,
  unknown;

  /// Determina se a candidatura esta legalmente autorizada a receber votos na urna.
  ///
  /// Conforme o art. 16-A da Lei das Eleicoes (Lei n. 9.504/1997), candidatos
  /// com registro sub judice (deferido ou indeferido com recurso, ou aguardando
  /// julgamento) tem direito de efetuar campanha eleitoral e constar na urna.
  bool get isEligibleToVote {
    return switch (this) {
      RegistrationStatus.deferred ||
      RegistrationStatus.deferredWithAppeal ||
      RegistrationStatus.waitingJudgment ||
      RegistrationStatus.ineligibleWithAppeal => true,
      RegistrationStatus.ineligible ||
      RegistrationStatus.cancelled ||
      RegistrationStatus.renunciation ||
      RegistrationStatus.deceased ||
      RegistrationStatus.revoked ||
      RegistrationStatus.substituted ||
      RegistrationStatus.unprocessed ||
      RegistrationStatus.unknown => false,
    };
  }
}
