import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quem_votar/core/network/akamai_interceptor.dart';
import 'package:quem_votar/core/network/circuit_breaker_interceptor.dart';
import 'package:quem_votar/core/network/network_constants.dart';
import 'package:quem_votar/core/network/tse_circuit_breaker.dart';

/// Fabrica responsavel pela criacao e configuracao do cliente HTTP Dio.
/// Define condicionalmente a URL base (Web vs Nativo) e adiciona os interceptors.
abstract final class TseDioClientFactory {
  /// Determina a URL base adequada com base na plataforma (Web vs Nativo).
  static String resolveBaseUrl({bool? isWeb}) {
    final web = isWeb ?? kIsWeb;
    if (web) {
      return NetworkConstants.webProxyBaseUrl;
    }
    return NetworkConstants.tseDirectBaseUrl;
  }

  /// Cria BaseOptions ajustando URLs relativas caso executado em runtime nao-web.
  static BaseOptions _createBaseOptions(String baseUrl) {
    final effectiveBaseUrl = (!kIsWeb && !Uri.parse(baseUrl).hasScheme)
        ? 'http://localhost$baseUrl'
        : baseUrl;

    return BaseOptions(
      baseUrl: effectiveBaseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.connectTimeout,
    );
  }

  /// Instancia um cliente Dio configurado para os contratos do TSE.
  static Dio create({
    String? customBaseUrl,
    bool? overrideIsWeb,
    List<Interceptor>? additionalInterceptors,
    HttpClientAdapter? customAdapter,
    TseCircuitBreaker? circuitBreaker,
  }) {
    final isWeb = overrideIsWeb ?? kIsWeb;
    final baseUrl = customBaseUrl ?? resolveBaseUrl(isWeb: isWeb);
    final dio = Dio(_createBaseOptions(baseUrl));

    if (customAdapter != null) {
      dio.httpClientAdapter = customAdapter;
    }
    if (circuitBreaker != null) {
      dio.interceptors.add(CircuitBreakerInterceptor(circuitBreaker: circuitBreaker));
    }
    dio.interceptors.add(AkamaiHeadersInterceptor(isWebPlatform: isWeb));
    if (additionalInterceptors != null) {
      dio.interceptors.addAll(additionalInterceptors);
    }
    return dio;
  }
}
