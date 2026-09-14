import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/network/dio_client_factory.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../core/network/fake_http_client_adapter.dart';

void main() {
  late FakeHttpClientAdapter fakeAdapter;
  late Dio dio;
  late TseRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeAdapter = FakeHttpClientAdapter();
    dio = TseDioClientFactory.create(
      customBaseUrl: 'https://divulgacandcontas.tse.jus.br/divulga/rest/v1/',
      customAdapter: fakeAdapter,
      overrideIsWeb: false,
    );
    dataSource = TseRemoteDataSourceImpl(dio: dio);
  });

  ResponseBody jsonResponse(String body, {int statusCode = 200}) {
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        'content-type': ['application/json; charset=utf-8'],
      },
    );
  }

  group('TseRemoteDataSourceImpl - getOrdinarias', () {
    test('retorna lista de ElectionDto ao receber HTTP 200 com payload JSON valido', () async {
      final fixture = TseFixtureReader.readFixture('eleicoes_ordinarias.json');
      fakeAdapter.responseHandler = (options) {
        expect(options.path, equals('eleicao/ordinarias'));
        return jsonResponse(fixture);
      };

      final result = await dataSource.getOrdinarias();

      expect(result.length, equals(3));
      expect(result.first.id, equals(20322002026));
      expect(result.first.year, equals(2026));
      expect(result.first.name, equals('Eleição Geral Federal 2026'));
      expect(result.first.type, equals('O'));
      expect(result.first.scope, equals('F'));
    });

    test('lanca AkamaiBlockedException quando o perimetro retorna HTTP 403', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"mensagem": "Acesso Negado"}', statusCode: 403);

      expect(() => dataSource.getOrdinarias(), throwsA(isA<AkamaiBlockedException>()));
    });

    test('lanca TseServerException quando o servidor retorna erro HTTP 500', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"mensagem": "Erro interno"}', statusCode: 500);

      expect(() => dataSource.getOrdinarias(), throwsA(isA<TseServerException>()));
    });

    test('lanca TseDataParseException quando o corpo retornado nao e uma lista', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"erro": "objeto_ao_inves_de_lista"}');

      expect(() => dataSource.getOrdinarias(), throwsA(isA<TseDataParseException>()));
    });
  });

  group('TseRemoteDataSourceImpl - getCargos', () {
    test('retorna CargosEnvelopeDto ao requisitar cargos para pleito e UF', () async {
      final fixture = TseFixtureReader.readFixture('cargos_br_2026.json');
      fakeAdapter.responseHandler = (options) {
        expect(options.path, equals('eleicao/listar/municipios/2040602026/BR/cargos'));
        return jsonResponse(fixture);
      };

      final envelope = await dataSource.getCargos(electionId: 2040602026, ufOrBr: 'br');

      expect(envelope.stateCode, equals('BR'));
      expect(envelope.cargos.length, equals(2));
      expect(envelope.cargos.first.code, equals(1));
      expect(envelope.cargos.first.name, equals('Presidente'));
      expect(envelope.cargos.first.sigla, equals('P'));
      expect(envelope.cargos.first.isTitular, isTrue);
    });

    test('lanca TseServerException caso a requisicao falhe com HTTP 404', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"mensagem": "Nao encontrado"}', statusCode: 404);

      expect(
        () => dataSource.getCargos(electionId: 2040602026, ufOrBr: 'BR'),
        throwsA(isA<TseServerException>()),
      );
    });

    test('lanca TseDataParseException quando o corpo nao puder ser mapeado em objeto', () async {
      fakeAdapter.responseHandler = (options) => jsonResponse('[1, 2, 3]');

      expect(
        () => dataSource.getCargos(electionId: 2040602026, ufOrBr: 'BR'),
        throwsA(isA<TseDataParseException>()),
      );
    });
  });

  group('TseRemoteDataSourceImpl - getCandidates', () {
    test('retorna CandidateListEnvelopeDto com candidatos parseados com sucesso', () async {
      final fixture = TseFixtureReader.readFixture('candidatos_presidente_2026.json');
      fakeAdapter.responseHandler = (options) {
        expect(options.path, equals('candidatura/listar/2026/BR/2040602026/1/candidatos'));
        return jsonResponse(fixture);
      };

      final envelope = await dataSource.getCandidates(
        year: 2026,
        ufOrMun: 'br',
        electionId: 2040602026,
        roleCode: 1,
      );

      expect(envelope.roleCode, equals(1));
      expect(envelope.roleName, equals('Presidente'));
      expect(envelope.candidates.length, equals(2));

      final firstCandidate = envelope.candidates.first;
      expect(firstCandidate.id, equals(280001612393));
      expect(firstCandidate.ballotNumber, equals(12));
      expect(firstCandidate.ballotName, equals('CIRO GOMES'));
      expect(firstCandidate.partyAcronym, equals('PDT'));
      expect(firstCandidate.totalAssets, isNull);
    });

    test('lanca AkamaiBlockedException em bloqueio 403 na listagem', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"erro": "WAF Blocked"}', statusCode: 403);

      expect(
        () => dataSource.getCandidates(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          roleCode: 1,
        ),
        throwsA(isA<AkamaiBlockedException>()),
      );
    });

    test('lanca TseDataParseException caso resposta seja lista em vez de envelope', () async {
      fakeAdapter.responseHandler = (options) => jsonResponse('["invalido"]');

      expect(
        () => dataSource.getCandidates(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          roleCode: 1,
        ),
        throwsA(isA<TseDataParseException>()),
      );
    });
  });

  group('TseRemoteDataSourceImpl - getCandidateDetail', () {
    test('retorna CandidateDetailDto integral ao buscar detalhe do candidato', () async {
      final fixture = TseFixtureReader.readFixture('candidato_detalhe_completo.json');
      fakeAdapter.responseHandler = (options) {
        expect(
          options.path,
          equals('candidatura/buscar/2026/BR/2040602026/candidato/280001612393'),
        );
        return jsonResponse(fixture);
      };

      final detail = await dataSource.getCandidateDetail(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 2040602026,
        candidateId: 280001612393,
      );

      expect(detail.id, equals(280001612393));
      expect(detail.ballotName, equals('CIRO GOMES'));
      expect(detail.fullName, equals('CIRO FERREIRA GOMES'));
      expect(detail.partyAcronym, equals('PDT'));
      expect(detail.assets.length, equals(2));
      expect(detail.runningMates.length, equals(1));
      expect(detail.runningMates.first.ballotName, equals('ANA PAULA MATOS'));
      expect(detail.files.length, equals(1));
      expect(detail.files.first.fileName, equals('proposta_de_governo_2026.pdf'));
    });

    test('lanca TseServerException em caso de erro HTTP 503 no detalhe', () async {
      fakeAdapter.responseHandler = (options) =>
          jsonResponse('{"mensagem": "Service Unavailable"}', statusCode: 503);

      expect(
        () => dataSource.getCandidateDetail(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          candidateId: 280001612393,
        ),
        throwsA(isA<TseServerException>()),
      );
    });

    test('lanca TseDataParseException quando o retorno for lista ao inves de mapa', () async {
      fakeAdapter.responseHandler = (options) => jsonResponse('[]');

      expect(
        () => dataSource.getCandidateDetail(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          candidateId: 280001612393,
        ),
        throwsA(isA<TseDataParseException>()),
      );
    });
  });
}
