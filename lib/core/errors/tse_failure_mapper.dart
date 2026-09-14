import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/errors/failures.dart';

/// Utilitario para conversao de excecoes de infraestrutura em falhas de dominio tipadas.
///
/// Garante isolamento estrito da camada de Dominio em relacao a exceptions de baixo nivel.
abstract final class TseFailureMapper {
  /// Converte qualquer excecao ou erro operacional na [Failure] correspondente.
  static Failure map(Object error, {required String operationalContext}) {
    if (error is Failure) return error;

    if (error is TseServerException) {
      return ServerFailure(
        statusCode: error.statusCode,
        message: error.message,
        operationalContext: error.operationalContext,
        cause: error,
      );
    }

    if (error is AkamaiBlockedException) {
      return ServerFailure(
        statusCode: error.statusCode,
        message: 'Acesso bloqueado pela protecao perimetral Akamai do TSE.',
        operationalContext: error.operationalContext,
        cause: error,
      );
    }

    if (error is CircuitBreakerOpenException) {
      return CircuitBreakerFailure(
        message: error.message,
        operationalContext: error.operationalContext,
        remainingCooldown: error.remainingCooldown,
        cause: error,
      );
    }

    if (error is TseDataParseException) {
      return ParsingFailure(
        message: error.message,
        operationalContext: error.operationalContext,
        receivedValue: error.receivedValue,
        expectedFormat: error.expectedFormat,
        cause: error,
      );
    }

    if (error is CacheException) {
      return CacheFailure(
        message: error.message,
        operationalContext: error.operationalContext,
        cause: error,
      );
    }

    return ServerFailure(
      message: 'Falha operacional nao tratada: $error',
      operationalContext: operationalContext,
      cause: error,
    );
  }
}
