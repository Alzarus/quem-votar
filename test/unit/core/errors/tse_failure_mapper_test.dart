import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/errors/tse_failure_mapper.dart';

void main() {
  const context = 'TestContext.run';

  group('TseFailureMapper - Conversao de Excecoes em Falhas de Dominio', () {
    test('deve retornar a propria Failure caso a entrada ja seja Failure', () {
      const original = NetworkFailure(message: 'Sem conexao', operationalContext: context);
      final result = TseFailureMapper.map(original, operationalContext: context);

      expect(result, equals(original));
    });

    test('deve converter TseServerException em ServerFailure preservando statusCode', () {
      const exception = TseServerException(
        statusCode: 502,
        message: 'Bad Gateway',
        operationalContext: context,
      );
      final failure = TseFailureMapper.map(exception, operationalContext: context);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, equals(502));
      expect(failure.message, equals('Bad Gateway'));
    });

    test('deve converter AkamaiBlockedException em ServerFailure com codigo 403', () {
      const exception = AkamaiBlockedException(
        statusCode: 403,
        requestUrl: 'https://tse.jus.br/api',
        operationalContext: context,
      );
      final failure = TseFailureMapper.map(exception, operationalContext: context);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, equals(403));
    });

    test('deve converter CircuitBreakerOpenException em CircuitBreakerFailure', () {
      const exception = CircuitBreakerOpenException(
        endpoint: '/candidatos',
        remainingCooldown: Duration(minutes: 3),
        operationalContext: context,
      );
      final failure = TseFailureMapper.map(exception, operationalContext: context);

      expect(failure, isA<CircuitBreakerFailure>());
      expect(
        (failure as CircuitBreakerFailure).remainingCooldown,
        equals(const Duration(minutes: 3)),
      );
    });

    test('deve converter TseDataParseException em ParsingFailure preservando valor e formato', () {
      const exception = TseDataParseException(
        receivedValue: 'abc',
        expectedFormat: 'numero double',
        operationalContext: context,
      );
      final failure = TseFailureMapper.map(exception, operationalContext: context);

      expect(failure, isA<ParsingFailure>());
      final pf = failure as ParsingFailure;
      expect(pf.receivedValue, equals('abc'));
      expect(pf.expectedFormat, equals('numero double'));
    });

    test('deve converter CacheException em CacheFailure', () {
      const exception = CacheException(message: 'Disco cheio', operationalContext: context);
      final failure = TseFailureMapper.map(exception, operationalContext: context);

      expect(failure, isA<CacheFailure>());
      expect(failure.message, equals('Disco cheio'));
    });

    test('deve converter excecoes genericas desconhecidas em ServerFailure', () {
      final genericException = Exception('Falha desconhecida');
      final failure = TseFailureMapper.map(genericException, operationalContext: context);

      expect(failure, isA<ServerFailure>());
      expect(failure.operationalContext, equals(context));
    });
  });
}
