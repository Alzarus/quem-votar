/// Constantes de rede e configuracoes de perimetro para comunicacao com o TSE.
/// Assegura integridade de cabecalhos contra o WAF Akamai e tempos de guarda.
abstract final class NetworkConstants {
  /// URL base direta dos servicos REST do TSE utilizada em Mobile e Desktop.
  static const String tseDirectBaseUrl = 'https://divulgacandcontas.tse.jus.br/divulga/rest/v1/';

  /// URL base relativa utilizada no Flutter Web, roteada pelo micro-proxy Nginx.
  static const String webProxyBaseUrl = '/quemvotar/api/';

  /// Tempo limite estrito para conexao (8 segundos conforme arquitetura).
  static const Duration connectTimeout = Duration(seconds: 8);

  /// Tempo limite estrito para recepcao de dados do servidor TSE.
  static const Duration receiveTimeout = Duration(seconds: 8);

  /// Cabecalho User-Agent emulado para evitar deteccao perimetral no Akamai.
  static const String userAgentHeader =
      'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36';

  /// Referer oficial exigido pela infraestrutura do TSE.
  static const String refererHeader = 'https://divulgacandcontas.tse.jus.br/';

  /// Origin oficial exigido para validacao de contexto no TSE.
  static const String originHeader = 'https://divulgacandcontas.tse.jus.br';

  /// Tipos de conteudo aceitos nas respostas da API.
  static const String acceptHeader = 'application/json, text/plain, */*';

  /// Idiomas preferenciais para compatibilidade perimetral.
  static const String acceptLanguageHeader = 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7';
}
