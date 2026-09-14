import 'package:equatable/equatable.dart';

/// Classe base abstrata para todas as falhas de dominio da aplicacao.
/// Encapsula erros de infraestrutura sem expor excecoes de baixo nivel.
abstract base class Failure extends Equatable {
  final String message;
  final String operationalContext;
  final Object? cause;

  const Failure({required this.message, required this.operationalContext, this.cause});

  @override
  List<Object?> get props => [message, operationalContext, cause];

  @override
  String toString() => '$runtimeType: $message [Contexto: $operationalContext]';
}

/// Representa falha decorrente de respostas anomalas ou erros de servidor TSE.
final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    required super.operationalContext,
    this.statusCode,
    super.cause,
  });

  @override
  List<Object?> get props => [message, operationalContext, statusCode, cause];
}

/// Representa falha de conectividade perimetral, timeout ou ausencia de rede.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, required super.operationalContext, super.cause});
}

/// Representa falha de leitura, gravacao ou corrupcao de dados no SQLite local.
final class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.operationalContext, super.cause});
}

/// Representa interrupcao preventiva efetuada pelo Circuit Breaker local.
final class CircuitBreakerFailure extends Failure {
  final Duration remainingCooldown;

  const CircuitBreakerFailure({
    required super.message,
    required super.operationalContext,
    required this.remainingCooldown,
    super.cause,
  });

  @override
  List<Object?> get props => [message, operationalContext, remainingCooldown, cause];
}

/// Representa incoerencia estrutural ou tipo invalido ao deserializar dados.
final class ParsingFailure extends Failure {
  final Object? receivedValue;
  final String expectedFormat;

  const ParsingFailure({
    required super.message,
    required super.operationalContext,
    required this.receivedValue,
    required this.expectedFormat,
    super.cause,
  });

  @override
  List<Object?> get props => [message, operationalContext, receivedValue, expectedFormat, cause];
}
