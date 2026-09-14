import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/network/dio_exception_mapper.dart';

void main() {
  group('DioExceptionMapper', () {
    final requestOptions = RequestOptions(
      path: '/candidatos',
      baseUrl: 'https://divulgacandcontas.tse.jus.br',
    );

    test('deve converter HTTP 403 em AkamaiBlockedException', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 403,
          statusMessage: 'Forbidden',
        ),
        type: DioExceptionType.badResponse,
      );

      final result = DioExceptionMapper.map(
        error: dioException,
        operationalContext: 'listagem de candidaturas',
      );

      expect(result, isA<AkamaiBlockedException>());
      final akamaiEx = result as AkamaiBlockedException;
      expect(akamaiEx.statusCode, equals(403));
      expect(akamaiEx.operationalContext, equals('listagem de candidaturas'));
    });

    test('deve converter HTTP 500 em TseServerException com status', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          statusMessage: 'Internal Server Error',
        ),
        type: DioExceptionType.badResponse,
      );

      final result = DioExceptionMapper.map(
        error: dioException,
        operationalContext: 'detalhe do candidato',
      );

      expect(result, isA<TseServerException>());
      final serverEx = result as TseServerException;
      expect(serverEx.statusCode, equals(500));
      expect(serverEx.operationalContext, equals('detalhe do candidato'));
    });

    test('deve mapear timeout de conexao para TseServerException com status nulo', () {
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
        message: 'Timeout ao conectar no perimetro do TSE',
      );

      final result = DioExceptionMapper.map(
        error: dioException,
        operationalContext: 'busca de partidos',
      );

      expect(result, isA<TseServerException>());
      final serverEx = result as TseServerException;
      expect(serverEx.statusCode, isNull);
      expect(serverEx.message, contains('Timeout ao conectar'));
    });
  });
}
