import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/data/repositories/election_repository_impl.dart';

import '../../../fixtures/fixture_reader.dart';

class MockTseRemoteDataSource extends Mock implements TseRemoteDataSource {}

void main() {
  late AppDatabase db;
  late CandidateLocalDataSource localDataSource;
  late MockTseRemoteDataSource remoteDataSource;
  late ElectionRepositoryImpl repository;
  late List<ElectionDto> electionsFixture;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    localDataSource = CandidateLocalDataSourceImpl(db: db);
    remoteDataSource = MockTseRemoteDataSource();
    repository = ElectionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      cacheTtl: const Duration(hours: 24),
    );

    final jsonList = TseFixtureReader.readJsonList('eleicoes_ordinarias.json');
    electionsFixture = jsonList
        .whereType<Map<String, dynamic>>()
        .map(ElectionDto.fromJson)
        .toList(growable: false);
  });

  tearDown(() async {
    await db.close();
  });

  group('ElectionRepositoryImpl - getElections', () {
    test('deve buscar remotamente, persistir no sqlite e gravar metadados', () async {
      when(() => remoteDataSource.getOrdinarias()).thenAnswer((_) async => electionsFixture);

      final result = await repository.getElections();

      expect(result.isSuccess, isTrue);
      final elections = result.successOrNull!;
      expect(elections.length, equals(electionsFixture.length));
      expect(elections.first.year, equals(2026));

      final local = await localDataSource.getElections();
      expect(local.length, equals(electionsFixture.length));
    });

    test('deve retornar dados locais imediatamente se o cache for recente', () async {
      when(() => remoteDataSource.getOrdinarias()).thenAnswer((_) async => electionsFixture);

      await repository.getElections();

      reset(remoteDataSource);

      final cachedResult = await repository.getElections();

      expect(cachedResult.isSuccess, isTrue);
      verifyZeroInteractions(remoteDataSource);
    });

    test('deve aplicar contingencia offline com dados locais caso remoto falhe', () async {
      when(() => remoteDataSource.getOrdinarias()).thenAnswer((_) async => electionsFixture);

      // Popula dados inicialmente
      await repository.getElections();

      // Forca expiracao do cache alterando metadados para data antiga
      await localDataSource.saveCacheMetadata(
        const CacheMetadataTableCompanion(
          cacheKey: Value('eleicoes_ordinarias'),
          lastFetchedAt: Value('2020-01-01T00:00:00.000Z'),
          payloadHash: Value('hash_antigo'),
          itemCount: Value(1),
        ),
      );

      // Simula erro de conexao na tentativa de revalidacao
      when(() => remoteDataSource.getOrdinarias()).thenThrow(
        const TseServerException(
          statusCode: 503,
          message: 'Servico Indisponivel',
          operationalContext: 'test',
        ),
      );

      final fallbackResult = await repository.getElections();

      expect(fallbackResult.isSuccess, isTrue);
      expect(fallbackResult.successOrNull!.isNotEmpty, isTrue);
    });

    test('deve propagar failure caso remoto falhe e nao existam dados locais', () async {
      when(() => remoteDataSource.getOrdinarias()).thenThrow(
        const TseServerException(
          statusCode: 500,
          message: 'Erro interno',
          operationalContext: 'test',
        ),
      );

      final failureResult = await repository.getElections();

      expect(failureResult.isFailure, isTrue);
      expect(failureResult.failureOrNull, isA<ServerFailure>());
    });
  });
}
