import 'package:dio/dio.dart';
import 'package:quem_votar/core/errors/exceptions.dart';

/// Utilitario para conversao de DioException em excecoes ricas de infraestrutura.
/// Centraliza a interpretacao de codigos perimetrais HTTP e falhas de conexao.
abstract final class DioExceptionMapper {
  /// Converte uma DioException na subclasse contextual correspondente de TseException.
  static TseException map({required DioException error, required String operationalContext}) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final requestUrl = error.requestOptions.uri.toString();

    if (statusCode == 403) {
      return AkamaiBlockedException(
        statusCode: 403,
        requestUrl: requestUrl,
        operationalContext: operationalContext,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return TseServerException(
        statusCode: statusCode,
        message: 'Servidor TSE retornou erro $statusCode: ${error.message}',
        operationalContext: operationalContext,
      );
    }

    return TseServerException(
      statusCode: statusCode,
      message: error.message ?? 'Falha de comunicacao com o servico do TSE.',
      operationalContext: operationalContext,
    );
  }
}
