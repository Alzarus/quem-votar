/// Hierarquia de excecoes operacionais com contexto rico.
/// Implementa a Regra 11 de Clean Code (excecoes informam valor, formato e contexto).
abstract class TseException implements Exception {
  final String message;
  final String operationalContext;

  const TseException({required this.message, required this.operationalContext});

  @override
  String toString() => '$runtimeType: $message [Contexto: $operationalContext]';
}

/// Lancada quando a desserializacao de um payload da API do TSE falha.
class TseDataParseException extends TseException {
  final Object? receivedValue;
  final String expectedFormat;

  const TseDataParseException({
    required this.receivedValue,
    required this.expectedFormat,
    required super.operationalContext,
    super.message = 'Falha no parsing de dados da API do TSE.',
  });

  @override
  String toString() {
    final base = super.toString();
    return '$base (Esperado: "$expectedFormat", Recebido: "$receivedValue")';
  }
}

/// Lancada quando o WAF Akamai intercepta a requisicao com desafio ou 403.
class AkamaiBlockedException extends TseException {
  final int statusCode;
  final String requestUrl;

  const AkamaiBlockedException({
    required this.statusCode,
    required this.requestUrl,
    required super.operationalContext,
    super.message = 'Requisicao bloqueada pelo WAF Akamai do TSE.',
  });

  @override
  String toString() {
    final base = super.toString();
    return '$base (HTTP $statusCode na URL: $requestUrl)';
  }
}

/// Lancada em respostas de erro do servidor TSE (ex: HTTP 5xx ou body invalido).
class TseServerException extends TseException {
  final int? statusCode;

  const TseServerException({
    required this.statusCode,
    required super.message,
    required super.operationalContext,
  });

  @override
  String toString() {
    final base = super.toString();
    return '$base (HTTP ${statusCode ?? "indefinido"})';
  }
}

/// Lancada em falhas de persistencia local ou indisponibilidade do Drift/SQLite.
class CacheException extends TseException {
  const CacheException({required super.message, required super.operationalContext});
}

/// Lancada preventivamente quando o disjuntor de circuito local esta aberto.
class CircuitBreakerOpenException extends TseException {
  final String endpoint;
  final Duration remainingCooldown;

  const CircuitBreakerOpenException({
    required this.endpoint,
    required this.remainingCooldown,
    required super.operationalContext,
    super.message = 'Circuito aberto. Requisicao interrompida preventivamente.',
  });

  @override
  String toString() {
    final base = super.toString();
    final seconds = remainingCooldown.inSeconds;
    return '$base (Endpoint: $endpoint, Cooldown: ${seconds}s)';
  }
}
