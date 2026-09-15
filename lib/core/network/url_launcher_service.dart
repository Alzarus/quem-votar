import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contrato abstrato para servicos de abertura de hiperlinks e documentos externos.
///
/// Viabiliza desacoplamento do framework nativo e injecao de fakes nomeados em testes.
abstract interface class UrlLauncherService {
  /// Abre o endereco informado no navegador ou aplicativo externo compativel.
  Future<bool> launchCandidateUrl(String rawUrl);
}

/// Implementacao padrao do servico de abertura de hiperlinks com suporte multiplataforma.
///
/// No ambiente Web, resolve rotas relativas do micro-proxy via [Uri.base.resolve]
/// e despacha a visualizacao em nova aba com destino `_blank`.
class DefaultUrlLauncherService implements UrlLauncherService {
  const DefaultUrlLauncherService();

  @override
  Future<bool> launchCandidateUrl(String rawUrl) async {
    final cleanUrl = rawUrl.trim();
    if (cleanUrl.isEmpty) {
      return false;
    }

    final targetUri = _resolveTargetUri(cleanUrl);
    try {
      final canLaunch = await canLaunchUrl(targetUri);
      if (!canLaunch) {
        return false;
      }

      return await launchUrl(
        targetUri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (_) {
      return false;
    }
  }

  /// Resolve URIs relativas originadas do micro-proxy no Web ou absolutas no mobile.
  Uri _resolveTargetUri(String url) {
    if (kIsWeb && url.startsWith('/')) {
      return Uri.base.resolve(url);
    }
    return Uri.parse(url);
  }
}
