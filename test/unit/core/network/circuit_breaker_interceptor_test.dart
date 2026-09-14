import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/network/circuit_breaker_interceptor.dart';
import 'package:quem_votar/core/network/circuit_breaker_state.dart';
import 'package:quem_votar/core/network/dio_client_factory.dart';
import 'package:quem_votar/core/network/tse_circuit_breaker.dart';
import 'fake_http_client_adapter.dart';

void main() {
  group('CircuitBreakerInterceptor', () {
    late FakeHttpClientAdapter adapter;
    late TseCircuitBreaker circuitBreaker;
    late Dio dio;

    setUp(() {
      adapter = FakeHttpClientAdapter();
      circuitBreaker = TseCircuitBreaker(
        failureThreshold: 3,
        failureWindow: const Duration(minutes: 2),
        cooldownDuration: const Duration(minutes: 5),
      );
      dio = Dio(BaseOptions(baseUrl: 'https://exemplo.com'));
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(CircuitBreakerInterceptor(circuitBreaker: circuitBreaker));
    });

    test('deve permitir requisicao normalmente quando circuito estiver fechado', () async {
      final response = await dio.get<String>('/teste');
      expect(response.statusCode, equals(200));
      expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
    });

    test('deve rejeitar requisicao preventivamente quando o circuito estiver aberto', () async {
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      circuitBreaker.recordFailure();
      expect(circuitBreaker.state, equals(CircuitBreakerState.open));

      try {
        await dio.get<String>('/teste');
        fail('Deveria ter lancado DioException');
      } on DioException catch (e) {
        expect(e.error, isA<CircuitBreakerOpenException>());
        final openEx = e.error! as CircuitBreakerOpenException;
        expect(openEx.remainingCooldown, isNotNull);
        expect(openEx.endpoint, contains('/teste'));
      }
    });

    test('deve registrar falha no disjuntor para erro HTTP 500 do servidor', () async {
      adapter.responseHandler = (options) {
        return ResponseBody.fromString('Erro interno', 500);
      };

      try {
        await dio.get<String>('/erro-500');
      } on DioException {
        // Excecao esperada do Dio para status 500
      }

      expect(circuitBreaker.failureCount, equals(1));
    });

    test('deve registrar falha no disjuntor para erro HTTP 502 Bad Gateway', () async {
      adapter.responseHandler = (options) {
        return ResponseBody.fromString('Bad Gateway', 502);
      };

      try {
        await dio.get<String>('/erro-502');
      } on DioException {
        // Excecao esperada
      }

      expect(circuitBreaker.failureCount, equals(1));
    });

    test('deve registrar falha no disjuntor para erro HTTP 504 Gateway Timeout', () async {
      adapter.responseHandler = (options) {
        return ResponseBody.fromString('Gateway Timeout', 504);
      };

      try {
        await dio.get<String>('/erro-504');
      } on DioException {
        // Excecao esperada
      }

      expect(circuitBreaker.failureCount, equals(1));
    });

    test(
      'nao deve registrar falha no disjuntor para status 404 (erro do cliente/recurso inexistente)',
      () async {
        adapter.responseHandler = (options) {
          return ResponseBody.fromString('Nao encontrado', 404);
        };

        try {
          await dio.get<String>('/nao-existe');
        } on DioException {
          // Excecao esperada do Dio para status 404
        }

        expect(circuitBreaker.failureCount, equals(0));
        expect(circuitBreaker.state, equals(CircuitBreakerState.closed));
      },
    );

    test('deve abrir o circuito apos 3 respostas HTTP 500 consecutivas', () async {
      adapter.responseHandler = (options) {
        return ResponseBody.fromString('Erro de servidor', 500);
      };

      for (var i = 0; i < 3; i++) {
        try {
          await dio.get<String>('/falha');
        } on DioException {
          // Ignora para acumular falhas
        }
      }

      expect(circuitBreaker.state, equals(CircuitBreakerState.open));

      // Quarta requisicao deve ser barrada preventivamente
      try {
        await dio.get<String>('/quarta');
        fail('Quarta requisicao deveria ter sido rejeitada');
      } on DioException catch (e) {
        expect(e.error, isA<CircuitBreakerOpenException>());
      }
    });

    test('TseDioClientFactory deve anexar CircuitBreakerInterceptor quando fornecido', () async {
      final client = TseDioClientFactory.create(
        customBaseUrl: 'https://exemplo.com',
        customAdapter: adapter,
        circuitBreaker: circuitBreaker,
      );

      final hasCircuitBreaker = client.interceptors.any((i) => i is CircuitBreakerInterceptor);
      expect(hasCircuitBreaker, isTrue);

      final response = await client.get<String>('/status');
      expect(response.statusCode, equals(200));
    });
  });
}
