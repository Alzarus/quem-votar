import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/repositories/candidate_repository_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockTseRemoteDataSource extends Mock implements TseRemoteDataSource {}

void main() {
  late AppDatabase db;
  late CandidateLocalDataSource localDataSource;
  late MockTseRemoteDataSource remoteDataSource;
  late CandidateRepositoryImpl repository;

  late CandidateListEnvelopeDto envelopeFixture;
  late CandidateDetailDto detailFixture;

  const year = 2026;
  const uf = 'BR';
  const electionId = 20322002026;
  const roleCode = 1;
  const candidateId = 280001612393;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    localDataSource = CandidateLocalDataSourceImpl(db: db);
    remoteDataSource = MockTseRemoteDataSource();
    repository = CandidateRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      cacheTtl: const Duration(minutes: 60),
    );

    final listJson = TseFixtureReader.readJsonMap('candidatos_presidente_2026.json');
    envelopeFixture = CandidateListEnvelopeDto.fromJson(listJson);

    final detailJson = TseFixtureReader.readJsonMap('candidato_detalhe_completo.json');
    detailFixture = CandidateDetailDto.fromJson(detailJson);
  });

  tearDown(() async {
    await db.close();
  });

  group('CandidateRepositoryImpl - getCandidates (Ciclo SWR)', () {
    test('deve buscar remotamente, persistir no sqlite e gravar metadados de cache', () async {
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenAnswer((_) async => envelopeFixture);

      final result = await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      expect(result.isSuccess, isTrue);
      final list = result.successOrNull!;
      expect(list.isNotEmpty, isTrue);
      expect(list.first.ballotName, equals('CIRO GOMES'));

      // Verificar persistencia relacional no SQLite
      final local = await localDataSource.getCandidates(
        electionId: electionId,
        stateCode: uf,
        roleCode: roleCode,
      );
      expect(local.length, equals(list.length));

      // Verificar metadados de cache gravados
      final metadata = await localDataSource.getCacheMetadata(
        '${year}_${uf}_${electionId}_$roleCode',
      );
      expect(metadata, isNotNull);
      expect(metadata!.itemCount, equals(envelopeFixture.candidates.length));
    });

    test('deve retornar dados locais imediatamente se o cache for recente (< 60 min)', () async {
      // 1. Primeira chamada remota para popular cache
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenAnswer((_) async => envelopeFixture);

      await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      reset(remoteDataSource);

      // 2. Segunda chamada imediata - nao deve acionar fonte remota
      final cachedResult = await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      expect(cachedResult.isSuccess, isTrue);
      verifyZeroInteractions(remoteDataSource);
    });

    test('deve revalidar e acionar fonte remota quando forceRefresh for verdadeiro', () async {
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenAnswer((_) async => envelopeFixture);

      // Popula cache
      await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      // Executa com forceRefresh: true
      final refreshResult = await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
        forceRefresh: true,
      );

      expect(refreshResult.isSuccess, isTrue);
      verify(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).called(2);
    });

    test('deve aplicar contingencia e retornar cache quando ocorrer falha remota', () async {
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenAnswer((_) async => envelopeFixture);

      // Popula cache inicialmente
      await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      // Simula erro remoto no refresh forçado
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenThrow(
        const AkamaiBlockedException(
          statusCode: 403,
          requestUrl: 'https://divulgacandcontas.tse.jus.br',
          operationalContext: 'test',
        ),
      );

      final fallbackResult = await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
        forceRefresh: true,
      );

      // Deve manter sucesso utilizando contingencia de dados locais
      expect(fallbackResult.isSuccess, isTrue);
      expect(fallbackResult.successOrNull!.isNotEmpty, isTrue);
    });

    test('deve retornar failure quando remoto falhar e nao houver cache local', () async {
      when(
        () => remoteDataSource.getCandidates(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          roleCode: roleCode,
        ),
      ).thenThrow(
        const TseServerException(
          statusCode: 500,
          message: 'Erro interno no TSE',
          operationalContext: 'test',
        ),
      );

      final failureResult = await repository.getCandidates(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        roleCode: roleCode,
      );

      expect(failureResult.isFailure, isTrue);
      expect(failureResult.failureOrNull, isA<ServerFailure>());
    });
  });

  group('CandidateRepositoryImpl - getCandidateDetail (Ciclo SWR)', () {
    test('deve buscar remotamente, persistir ficha cadastral, bens e vices', () async {
      when(
        () => remoteDataSource.getCandidateDetail(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          candidateId: candidateId,
        ),
      ).thenAnswer((_) async => detailFixture);

      final result = await repository.getCandidateDetail(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        candidateId: candidateId,
      );

      expect(result.isSuccess, isTrue);
      final detail = result.successOrNull!;
      expect(detail.id, equals(candidateId));
      expect(detail.assets.length, equals(detailFixture.assets.length));
      expect(detail.runningMates.length, equals(detailFixture.runningMates.length));

      // Validar persistencia relacional de agregacao
      final record = await localDataSource.getCandidateDetailRecord(candidateId);
      expect(record, isNotNull);
      expect(record!.candidate.detailFetched, isTrue);
      expect(record.assets.length, equals(detailFixture.assets.length));
    });

    test('deve retornar detalhe em cache recente sem chamar fonte remota', () async {
      when(
        () => remoteDataSource.getCandidateDetail(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          candidateId: candidateId,
        ),
      ).thenAnswer((_) async => detailFixture);

      await repository.getCandidateDetail(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        candidateId: candidateId,
      );

      reset(remoteDataSource);

      final cachedResult = await repository.getCandidateDetail(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        candidateId: candidateId,
      );

      expect(cachedResult.isSuccess, isTrue);
      verifyZeroInteractions(remoteDataSource);
    });

    test('deve aplicar contingencia offline retornando ficha local caso remoto falhe', () async {
      when(
        () => remoteDataSource.getCandidateDetail(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          candidateId: candidateId,
        ),
      ).thenAnswer((_) async => detailFixture);

      await repository.getCandidateDetail(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        candidateId: candidateId,
      );

      when(
        () => remoteDataSource.getCandidateDetail(
          year: year,
          ufOrMun: uf,
          electionId: electionId,
          candidateId: candidateId,
        ),
      ).thenThrow(
        const TseServerException(
          statusCode: 504,
          message: 'Gateway Timeout',
          operationalContext: 'test',
        ),
      );

      final fallbackResult = await repository.getCandidateDetail(
        year: year,
        ufOrMun: uf,
        electionId: electionId,
        candidateId: candidateId,
        forceRefresh: true,
      );

      expect(fallbackResult.isSuccess, isTrue);
      expect(fallbackResult.successOrNull!.id, equals(candidateId));
    });
  });
}
