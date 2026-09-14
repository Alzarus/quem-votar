/// Utilitario para construcao canonica de URLs da infraestrutura do TSE.
///
/// Centraliza a geracao de enderecos de midias (fotografias em alta e baixa
/// resolucao) e documentos anexos (propostas de governo em formato PDF).
abstract final class TseUrlBuilder {
  static const String _tseArchiveBase = 'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo';
  static const String _tseApiBase = 'https://divulgacandcontas.tse.jus.br/divulga/rest/v1';

  /// Monta a URL oficial da fotografia de urna em alta resolucao (~320x400px).
  static String buildUrnaPhotoUrl({
    required int electionId,
    required int candidateId,
    required String ufOrMun,
  }) {
    final cleanUf = ufOrMun.trim().toUpperCase();
    return '$_tseArchiveBase/img/$electionId/$candidateId/$cleanUf';
  }

  /// Monta a URL oficial da fotografia de urna em baixa resolucao (~100x130px).
  static String buildThumbnailPhotoUrl({
    required int electionId,
    required int candidateId,
    int version = 1,
  }) {
    return '$_tseApiBase/candidatura/buscar/foto/$electionId/$candidateId/$version';
  }

  /// Monta a URL de visualizacao e download de documentos anexos (PDF).
  static String buildProposalDocumentUrl(int fileId) {
    return '$_tseArchiveBase/doc/$fileId';
  }
}
