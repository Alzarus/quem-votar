import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';

void main() {
  group('TseDataParseException', () {
    test('deve instanciar com contexto rico e formatar toString adequadamente', () {
      const exception = TseDataParseException(
        receivedValue: 'invalido',
        expectedFormat: 'int',
        operationalContext: 'parsing do id de candidatura',
      );

      expect(exception.receivedValue, equals('invalido'));
      expect(exception.expectedFormat, equals('int'));
      expect(exception.operationalContext, equals('parsing do id de candidatura'));
      expect(exception.toString(), contains('Esperado: "int", Recebido: "invalido"'));
    });
  });

  group('AkamaiBlockedException', () {
    test('deve conter codigo HTTP, URL da requisicao e mensagem especifica', () {
      const exception = AkamaiBlockedException(
        statusCode: 403,
        requestUrl: 'https://divulgacandcontas.tse.jus.br/divulga/rest/v1/eleicao',
        operationalContext: 'consulta de eleicoes ordinarias',
      );

      expect(exception.statusCode, equals(403));
      expect(exception.requestUrl, contains('divulgacandcontas.tse.jus.br'));
      expect(exception.operationalContext, equals('consulta de eleicoes ordinarias'));
      expect(exception.toString(), contains('HTTP 403'));
    });
  });

  group('TseServerException', () {
    test('deve registrar status code e mensagem operacional de falha', () {
      const exception = TseServerException(
        statusCode: 502,
        message: 'Bad Gateway do gateway perimetral',
        operationalContext: 'requisicao de detalhes de candidato',
      );

      expect(exception.statusCode, equals(502));
      expect(exception.message, equals('Bad Gateway do gateway perimetral'));
      expect(exception.operationalContext, equals('requisicao de detalhes de candidato'));
      expect(exception.toString(), contains('HTTP 502'));
    });
  });

  group('CacheException', () {
    test('deve conter descricao da falha de persistencia e contexto', () {
      const exception = CacheException(
        message: 'Erro de gravacao no SQLite',
        operationalContext: 'armazenamento de bens declarados',
      );

      expect(exception.message, equals('Erro de gravacao no SQLite'));
      expect(exception.operationalContext, equals('armazenamento de bens declarados'));
      expect(exception.toString(), contains('CacheException'));
    });
  });

  group('CircuitBreakerOpenException', () {
    test('deve conter duracao de cooldown e endpoint protegido', () {
      const cooldown = Duration(seconds: 180);
      const exception = CircuitBreakerOpenException(
        endpoint: '/candidatos/listar',
        remainingCooldown: cooldown,
        operationalContext: 'contencao preventiva de trafego',
      );

      expect(exception.endpoint, equals('/candidatos/listar'));
      expect(exception.remainingCooldown.inSeconds, equals(180));
      expect(exception.toString(), contains('Cooldown: 180s'));
    });
  });
}
