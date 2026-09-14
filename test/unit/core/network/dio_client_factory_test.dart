import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/akamai_interceptor.dart';
import 'package:quem_votar/core/network/dio_client_factory.dart';
import 'package:quem_votar/core/network/network_constants.dart';
import 'fake_http_client_adapter.dart';

void main() {
  group('TseDioClientFactory', () {
    test('deve resolver Base URL relativa para plataforma Web', () {
      final url = TseDioClientFactory.resolveBaseUrl(isWeb: true);
      expect(url, equals(NetworkConstants.webProxyBaseUrl));
    });

    test('deve resolver Base URL direta do TSE para plataformas nativas', () {
      final url = TseDioClientFactory.resolveBaseUrl(isWeb: false);
      expect(url, equals(NetworkConstants.tseDirectBaseUrl));
    });

    test('deve criar cliente com Base URL direta em ambiente nativo', () {
      final dio = TseDioClientFactory.create(overrideIsWeb: false);
      expect(dio.options.baseUrl, equals(NetworkConstants.tseDirectBaseUrl));
    });

    test('deve criar cliente com fallback compativel com VM quando simulando Web', () {
      final dio = TseDioClientFactory.create(overrideIsWeb: true);
      expect(dio.options.baseUrl, contains(NetworkConstants.webProxyBaseUrl));
    });

    test('deve permitir sobreposicao por Base URL customizada', () {
      final dio = TseDioClientFactory.create(customBaseUrl: 'https://homologacao.tse.jus.br/');
      expect(dio.options.baseUrl, equals('https://homologacao.tse.jus.br/'));
    });

    test('deve configurar tempos de conexao e recepcao com 8 segundos', () {
      final dio = TseDioClientFactory.create();
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 8)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 8)));
      expect(dio.options.sendTimeout, equals(const Duration(seconds: 8)));
    });

    test('deve registrar o AkamaiHeadersInterceptor automaticamente', () {
      final dio = TseDioClientFactory.create();
      final hasAkamaiInterceptor = dio.interceptors.any(
        (interceptor) => interceptor is AkamaiHeadersInterceptor,
      );
      expect(hasAkamaiInterceptor, isTrue);
    });

    test('deve anexar adaptador customizado e interceptors adicionais', () {
      final adapter = FakeHttpClientAdapter();
      final extraInterceptor = LogInterceptor();

      final dio = TseDioClientFactory.create(
        customAdapter: adapter,
        additionalInterceptors: [extraInterceptor],
      );

      expect(dio.httpClientAdapter, equals(adapter));
      expect(dio.interceptors.contains(extraInterceptor), isTrue);
    });
  });
}
