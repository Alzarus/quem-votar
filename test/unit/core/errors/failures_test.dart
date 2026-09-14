import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/failures.dart';

void main() {
  group('ServerFailure', () {
    test('deve suportar comparacao de igualdade por valor via Equatable', () {
      const failure1 = ServerFailure(
        message: 'Servidor indisponivel',
        operationalContext: 'busca de candidatos',
        statusCode: 503,
      );
      const failure2 = ServerFailure(
        message: 'Servidor indisponivel',
        operationalContext: 'busca de candidatos',
        statusCode: 503,
      );

      expect(failure1, equals(failure2));
      expect(failure1.statusCode, equals(503));
      expect(failure1.toString(), contains('ServerFailure: Servidor indisponivel'));
    });
  });

  group('NetworkFailure', () {
    test('deve encapsular falha de rede e manter igualdade semantica', () {
      const failure1 = NetworkFailure(
        message: 'Conexao recusada pelo host remoto',
        operationalContext: 'download de fotos',
      );
      const failure2 = NetworkFailure(
        message: 'Conexao recusada pelo host remoto',
        operationalContext: 'download de fotos',
      );

      expect(failure1, equals(failure2));
      expect(failure1.props, contains('download de fotos'));
    });
  });

  group('CacheFailure', () {
    test('deve representar falha local com contexto operacional', () {
      const failure1 = CacheFailure(
        message: 'Registro nao localizado na tabela local',
        operationalContext: 'leitura de bens',
      );
      const failure2 = CacheFailure(
        message: 'Registro nao localizado na tabela local',
        operationalContext: 'leitura de bens',
      );

      expect(failure1, equals(failure2));
      expect(failure1.message, equals('Registro nao localizado na tabela local'));
    });
  });

  group('CircuitBreakerFailure', () {
    test('deve conter duracao de cooldown e ser comparavel por valor', () {
      const cooldown = Duration(minutes: 5);
      const failure1 = CircuitBreakerFailure(
        message: 'Circuito aberto',
        operationalContext: 'bloqueio temporario de endpoint',
        remainingCooldown: cooldown,
      );
      const failure2 = CircuitBreakerFailure(
        message: 'Circuito aberto',
        operationalContext: 'bloqueio temporario de endpoint',
        remainingCooldown: cooldown,
      );

      expect(failure1, equals(failure2));
      expect(failure1.remainingCooldown, equals(cooldown));
    });
  });

  group('ParsingFailure', () {
    test('deve registrar valor recebido e formato esperado', () {
      const failure1 = ParsingFailure(
        message: 'Formato numerico corrompido',
        operationalContext: 'conversao de patrimonio financeiro',
        receivedValue: 'dez mil',
        expectedFormat: 'double',
      );
      const failure2 = ParsingFailure(
        message: 'Formato numerico corrompido',
        operationalContext: 'conversao de patrimonio financeiro',
        receivedValue: 'dez mil',
        expectedFormat: 'double',
      );

      expect(failure1, equals(failure2));
      expect(failure1.receivedValue, equals('dez mil'));
      expect(failure1.expectedFormat, equals('double'));
    });
  });
}
