import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';

void main() {
  const tFailure = ServerFailure(
    message: 'Servidor fora do ar',
    operationalContext: 'teste de unidade',
  );

  group('Result - Sucesso', () {
    const Result<int, ServerFailure> result = Result.success(42);

    test('deve sinalizar isSuccess verdadeiro e isFailure falso', () {
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('deve retornar valor em successOrNull e null em failureOrNull', () {
      expect(result.successOrNull, equals(42));
      expect(result.failureOrNull, isNull);
    });

    test('deve executar callback onSuccess no fold', () {
      final value = result.fold((failure) => -1, (success) => success * 2);
      expect(value, equals(84));
    });

    test('deve executar callback success no when', () {
      final value = result.when(success: (s) => 'Valor: $s', failure: (f) => 'Erro: ${f.message}');
      expect(value, equals('Valor: 42'));
    });

    test('deve suportar comparacao de igualdade por valor', () {
      const other = Success<int, ServerFailure>(42);
      expect(result, equals(other));
    });

    test('deve funcionar com pattern matching exaustivo do Dart 3', () {
      final text = switch (result) {
        Success(:final value) => 'Recebido: $value',
        FailureResult(:final failure) => 'Falhou: ${failure.message}',
      };
      expect(text, equals('Recebido: 42'));
    });
  });

  group('Result - Falha', () {
    const Result<int, ServerFailure> result = Result.failure(tFailure);

    test('deve sinalizar isFailure verdadeiro e isSuccess falso', () {
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
    });

    test('deve retornar null em successOrNull e failure em failureOrNull', () {
      expect(result.successOrNull, isNull);
      expect(result.failureOrNull, equals(tFailure));
    });

    test('deve executar callback onFailure no fold', () {
      final value = result.fold((failure) => failure.message, (success) => 'Sucesso inesperado');
      expect(value, equals('Servidor fora do ar'));
    });

    test('deve executar callback failure no when', () {
      final value = result.when(success: (s) => 'OK: $s', failure: (f) => 'Erro: ${f.message}');
      expect(value, equals('Erro: Servidor fora do ar'));
    });

    test('deve suportar comparacao de igualdade por valor', () {
      const other = FailureResult<int, ServerFailure>(tFailure);
      expect(result, equals(other));
    });

    test('deve funcionar com pattern matching exaustivo do Dart 3', () {
      final text = switch (result) {
        Success(:final value) => 'Recebido: $value',
        FailureResult(:final failure) => 'Falhou: ${failure.message}',
      };
      expect(text, equals('Falhou: Servidor fora do ar'));
    });
  });
}
