import 'package:dio/dio.dart';
import 'package:quem_votar/core/network/network_constants.dart';

/// Interceptor Dio responsavel por injetar os cabecalhos de contexto necessarios
/// para evitar bloqueios automatizados pelo WAF Akamai EdgeSuite do TSE.
class AkamaiHeadersInterceptor extends Interceptor {
  final bool isWebPlatform;

  const AkamaiHeadersInterceptor({this.isWebPlatform = false});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = NetworkConstants.acceptHeader;
    options.headers['Accept-Language'] = NetworkConstants.acceptLanguageHeader;

    // Em ambiente Web, cabecalhos restritos como User-Agent, Referer e Origin
    // sao controlados pelo navegador e gerenciados pelo micro-proxy Nginx.
    if (!isWebPlatform) {
      options.headers['User-Agent'] = NetworkConstants.userAgentHeader;
      options.headers['Referer'] = NetworkConstants.refererHeader;
      options.headers['Origin'] = NetworkConstants.originHeader;
    }

    handler.next(options);
  }
}
