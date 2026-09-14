import 'package:flutter/foundation.dart';

/// Utilitario para construcao canonica de URLs da infraestrutura do TSE.
///
/// Centraliza a geracao de enderecos de midias (fotografias em alta e baixa
/// resolucao) e documentos anexos (propostas de governo em formato PDF).
abstract final class TseUrlBuilder {
  static const String _tseArchiveBase = 'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo';
  static const String _tseApiBase = 'https://divulgacandcontas.tse.jus.br/divulga/rest/v1';
  static const String _webProxyArchiveBase = '/quemvotar/api/arquivo';
  static const String _webProxyApiBase = '/quemvotar/api';

  /// Monta a URL oficial da fotografia de urna em alta resolucao (~320x400px).
  static String buildUrnaPhotoUrl({
    required int electionId,
    required int candidateId,
    required String ufOrMun,
    bool? isWeb,
  }) {
    final cleanUf = ufOrMun.trim().toUpperCase();
    final canonical = '$_tseArchiveBase/img/$electionId/$candidateId/$cleanUf';
    return formatMediaUrl(canonical, isWeb: isWeb);
  }

  /// Monta a URL oficial da fotografia de urna em baixa resolucao (~100x130px).
  static String buildThumbnailPhotoUrl({
    required int electionId,
    required int candidateId,
    int version = 1,
    bool? isWeb,
  }) {
    final canonical = '$_tseApiBase/candidatura/buscar/foto/$electionId/$candidateId/$version';
    return formatMediaUrl(canonical, isWeb: isWeb);
  }

  /// Monta a URL de visualizacao e download de documentos anexos (PDF).
  static String buildProposalDocumentUrl(int fileId, {bool? isWeb}) {
    final canonical = '$_tseArchiveBase/doc/$fileId';
    return formatMediaUrl(canonical, isWeb: isWeb);
  }

  /// Converte enderecos absolutos do TSE para rotas do micro-proxy no Flutter Web
  /// com o objetivo de contornar restricoes perimetrais de CORS e Akamai.
  static String formatMediaUrl(String rawUrl, {bool? isWeb}) {
    final useWeb = isWeb ?? kIsWeb;
    if (!useWeb) return rawUrl;

    if (rawUrl.startsWith(_tseArchiveBase)) {
      return rawUrl.replaceFirst(_tseArchiveBase, _webProxyArchiveBase);
    }
    if (rawUrl.startsWith(_tseApiBase)) {
      return rawUrl.replaceFirst(_tseApiBase, _webProxyApiBase);
    }
    return rawUrl;
  }
}
