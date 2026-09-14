import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/akamai_interceptor.dart';
import 'package:quem_votar/core/network/network_constants.dart';
import 'fake_http_client_adapter.dart';

void main() {
  group('AkamaiHeadersInterceptor', () {
    test('deve injetar todos os cabecalhos Akamai em ambiente nativo/mobile', () async {
      final adapter = FakeHttpClientAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://exemplo.com'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(const AkamaiHeadersInterceptor(isWebPlatform: false));

      await dio.get<String>('/teste');

      final headers = adapter.lastRequestOptions?.headers;
      expect(headers, isNotNull);
      expect(headers?['User-Agent'], equals(NetworkConstants.userAgentHeader));
      expect(headers?['Referer'], equals(NetworkConstants.refererHeader));
      expect(headers?['Origin'], equals(NetworkConstants.originHeader));
      expect(headers?['Accept'], equals(NetworkConstants.acceptHeader));
      expect(headers?['Accept-Language'], equals(NetworkConstants.acceptLanguageHeader));
    });

    test('deve omitir User-Agent, Referer e Origin em ambiente Web (delegado ao Nginx)', () async {
      final adapter = FakeHttpClientAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://exemplo.com'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(const AkamaiHeadersInterceptor(isWebPlatform: true));

      await dio.get<String>('/teste');

      final headers = adapter.lastRequestOptions?.headers;
      expect(headers, isNotNull);
      expect(headers?['User-Agent'], isNull);
      expect(headers?['Referer'], isNull);
      expect(headers?['Origin'], isNull);
      expect(headers?['Accept'], equals(NetworkConstants.acceptHeader));
      expect(headers?['Accept-Language'], equals(NetworkConstants.acceptLanguageHeader));
    });
  });
}
