import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'tse_circuit_breaker.dart';

/// Interceptor Dio que bloqueia requisicoes preventivamente quando o disjuntor abre
/// e computa falhas de infraestrutura (timeouts e respostas HTTP 5xx).
class CircuitBreakerInterceptor extends Interceptor {
  final TseCircuitBreaker circuitBreaker;

  CircuitBreakerInterceptor({required this.circuitBreaker});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!circuitBreaker.canExecute()) {
      final exception = CircuitBreakerOpenException(
        endpoint: options.uri.toString(),
        remainingCooldown: circuitBreaker.getRemainingCooldown(),
        operationalContext: 'CircuitBreakerInterceptor.onRequest',
      );
      handler.reject(
        DioException(requestOptions: options, error: exception, type: DioExceptionType.unknown),
      );
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    if (status != null && status >= 200 && status < 400) {
      circuitBreaker.recordSuccess();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isInfrastructureFailure(err)) {
      circuitBreaker.recordFailure();
    }
    handler.next(err);
  }

  bool _isInfrastructureFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        return status != null && status >= 500;
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return false;
    }
  }
}
