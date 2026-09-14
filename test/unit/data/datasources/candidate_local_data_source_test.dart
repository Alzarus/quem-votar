import 'dart:async';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';

void main() {
  late AppDatabase db;
  late CandidateLocalDataSource dataSource;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dataSource = CandidateLocalDataSourceImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('CandidateLocalDataSource - Pleitos Eleitorais (Elections)', () {
    test('deve salvar lista vazia de pleitos sem erros', () async {
      await dataSource.saveElections(const []);
      final elections = await dataSource.getElections();
      expect(elections, isEmpty);
    });

    test('deve salvar e consultar pleitos ordenados por ano decrescente', () async {
      final companions = [
        _createElectionCompanion(id: 20322002022, ano: 2022, nome: 'Eleicoes Gerais 2022'),
        _createElectionCompanion(id: 20322002026, ano: 2026, nome: 'Eleicoes Gerais 2026'),
      ];

      await dataSource.saveElections(companions);
      final list = await dataSource.getElections();

      expect(list.length, equals(2));
      expect(list.first.ano, equals(2026));
      expect(list.last.ano, equals(2022));
    });

    test('deve consultar pleito por identificador oficial', () async {
      const electionId = 20322002026;
      await dataSource.saveElections([
        _createElectionCompanion(id: electionId, ano: 2026, nome: 'Eleicoes Gerais 2026'),
      ]);

      final found = await dataSource.getElectionById(electionId);
      final notFound = await dataSource.getElectionById(999999);

      expect(found, isNotNull);
      expect(found!.id, equals(electionId));
      expect(notFound, isNull);
    });

    test('deve emitir pleitos em stream reativo via watchElections', () async {
      final stream = dataSource.watchElections();

      unawaited(expectLater(stream, emitsInOrder([isEmpty, hasLength(1)])));

      await Future<void>.delayed(const Duration(milliseconds: 20));
      await dataSource.saveElections([
        _createElectionCompanion(id: 20322002026, ano: 2026, nome: 'Eleicoes 2026'),
      ]);
    });
  });

  group('CandidateLocalDataSource - Cargos Disponiveis (ElectionsCargos)', () {
    const electionId = 20322002026;

    setUp(() async {
      await dataSource.saveElections([
        _createElectionCompanion(id: electionId, ano: 2026, nome: 'Eleicoes 2026'),
      ]);
    });

    test('deve salvar e consultar cargos ordenados por cargoCode crescente', () async {
      final cargos = [
        _createCargoCompanion(electionId: electionId, stateCode: 'BR', cargoCode: 2, nome: 'Vice'),
        _createCargoCompanion(
          electionId: electionId,
          stateCode: 'BR',
          cargoCode: 1,
          nome: 'Presidente',
        ),
      ];

      await dataSource.saveCargos(electionId: electionId, stateCode: 'BR', cargos: cargos);
      final result = await dataSource.getCargos(electionId: electionId, stateCode: 'BR');

      expect(result.length, equals(2));
      expect(result.first.cargoCode, equals(1));
      expect(result.last.cargoCode, equals(2));
    });

    test('deve substituir cargos anteriores em nova gravacao para mesma UF', () async {
      final initial = [
        _createCargoCompanion(electionId: electionId, stateCode: 'SP', cargoCode: 3, nome: 'Gov'),
      ];
      await dataSource.saveCargos(electionId: electionId, stateCode: 'SP', cargos: initial);

      final updated = [
        _createCargoCompanion(electionId: electionId, stateCode: 'SP', cargoCode: 5, nome: 'Sen'),
      ];
      await dataSource.saveCargos(electionId: electionId, stateCode: 'SP', cargos: updated);

      final result = await dataSource.getCargos(electionId: electionId, stateCode: 'SP');
      expect(result.length, equals(1));
      expect(result.first.cargoCode, equals(5));
    });
  });

  group('CandidateLocalDataSource - Listagem de Candidatos (Candidates)', () {
    const electionId = 20322002026;

    setUp(() async {
      await dataSource.saveElections([
        _createElectionCompanion(id: electionId, ano: 2026, nome: 'Eleicoes 2026'),
      ]);
    });

    test('deve salvar candidatos e vices e recuperar ordenados por ballotName ASC', () async {
      final candidates = [
        _createCandidateCompanion(
          id: 102,
          electionId: electionId,
          ballotName: 'ZE SILVA',
          roleCode: 1,
        ),
        _createCandidateCompanion(
          id: 101,
          electionId: electionId,
          ballotName: 'ANA SOUZA',
          roleCode: 1,
        ),
      ];
      final runningMates = [
        _createCandidateCompanion(
          id: 201,
          electionId: electionId,
          ballotName: 'VICE ANA',
          roleCode: 2,
          parentCandidateId: 101,
        ),
      ];

      await dataSource.saveCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        candidates: candidates,
        runningMates: runningMates,
      );

      final list = await dataSource.getCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
      );

      expect(list.length, equals(2));
      expect(list.first.ballotName, equals('ANA SOUZA'));
      expect(list.last.ballotName, equals('ZE SILVA'));

      final mates = await dataSource.getRunningMates(101);
      expect(mates.length, equals(1));
      expect(mates.first.ballotName, equals('VICE ANA'));
    });

    test('deve preservar flag detailFetched=true durante re-sincronizacao da listagem', () async {
      const candidateId = 101;
      await dataSource.saveCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        candidates: [
          _createCandidateCompanion(
            id: candidateId,
            electionId: electionId,
            ballotName: 'CANDIDATO TESTE',
            roleCode: 1,
          ),
        ],
      );

      // Marca como detalhado
      await dataSource.saveCandidateDetail(
        candidate: _createCandidateCompanion(
          id: candidateId,
          electionId: electionId,
          ballotName: 'CANDIDATO TESTE',
          roleCode: 1,
          detailFetched: true,
          birthDate: '01/01/1980',
        ),
        assets: const [],
      );

      var check = await dataSource.getCandidateById(candidateId);
      expect(check!.detailFetched, isTrue);

      // Atualiza listagem trazendo detailFetched = false (padrao da listagem DTO)
      await dataSource.saveCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        candidates: [
          _createCandidateCompanion(
            id: candidateId,
            electionId: electionId,
            ballotName: 'CANDIDATO TESTE ATUALIZADO',
            roleCode: 1,
            detailFetched: false,
          ),
        ],
      );

      check = await dataSource.getCandidateById(candidateId);
      expect(check!.detailFetched, isTrue);
      expect(check.ballotName, equals('CANDIDATO TESTE ATUALIZADO'));
    });

    test('deve emitir stream reativo de candidatos via watchCandidates', () async {
      final stream = dataSource.watchCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
      );

      unawaited(expectLater(stream, emitsInOrder([isEmpty, hasLength(1)])));

      await Future<void>.delayed(const Duration(milliseconds: 20));
      await dataSource.saveCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        candidates: [
          _createCandidateCompanion(
            id: 101,
            electionId: electionId,
            ballotName: 'ANA',
            roleCode: 1,
          ),
        ],
      );
    });
  });

  group('CandidateLocalDataSource - Ficha Cadastral, Bens e Vices', () {
    const electionId = 20322002026;
    const candidateId = 101;

    setUp(() async {
      await dataSource.saveElections([
        _createElectionCompanion(id: electionId, ano: 2026, nome: 'Eleicoes 2026'),
      ]);
      await dataSource.saveCandidates(
        electionId: electionId,
        stateCode: 'BR',
        roleCode: 1,
        candidates: [
          _createCandidateCompanion(
            id: candidateId,
            electionId: electionId,
            ballotName: 'TITULAR',
            roleCode: 1,
          ),
        ],
      );
    });

    test('deve salvar e consultar CandidateDetailRecord com bens e chapa', () async {
      final assets = [
        _createAssetCompanion(candidateId: candidateId, order: 1, amount: 200000.0),
        _createAssetCompanion(candidateId: candidateId, order: 2, amount: 800000.0),
      ];
      final mates = [
        _createCandidateCompanion(
          id: 201,
          electionId: electionId,
          ballotName: 'VICE DO TITULAR',
          roleCode: 2,
          parentCandidateId: candidateId,
        ),
      ];

      await dataSource.saveCandidateDetail(
        candidate: _createCandidateCompanion(
          id: candidateId,
          electionId: electionId,
          ballotName: 'TITULAR',
          roleCode: 1,
          birthDate: '15/03/1975',
          gender: 'FEMININO',
          detailFetched: true,
        ),
        assets: assets,
        runningMates: mates,
      );

      final record = await dataSource.getCandidateDetailRecord(candidateId);

      expect(record, isNotNull);
      expect(record!.candidate.id, equals(candidateId));
      expect(record.candidate.birthDate, equals('15/03/1975'));
      expect(record.candidate.gender, equals('FEMININO'));
      expect(record.candidate.detailFetched, isTrue);

      expect(record.assets.length, equals(2));
      expect(record.assets.first.amount, equals(800000.0));
      expect(record.assets.last.amount, equals(200000.0));

      expect(record.runningMates.length, equals(1));
      expect(record.runningMates.first.ballotName, equals('VICE DO TITULAR'));
    });

    test('deve retornar null em getCandidateDetailRecord para candidato inexistente', () async {
      final record = await dataSource.getCandidateDetailRecord(99999);
      expect(record, isNull);
    });

    test('deve substituir bens existentes em novas chamadas a saveCandidateDetail', () async {
      final initialAssets = [
        _createAssetCompanion(candidateId: candidateId, order: 1, amount: 50000.0),
      ];
      await dataSource.saveCandidateDetail(
        candidate: _createCandidateCompanion(
          id: candidateId,
          electionId: electionId,
          ballotName: 'TITULAR',
          roleCode: 1,
        ),
        assets: initialAssets,
      );

      final updatedAssets = [
        _createAssetCompanion(candidateId: candidateId, order: 1, amount: 150000.0),
        _createAssetCompanion(candidateId: candidateId, order: 2, amount: 300000.0),
      ];
      await dataSource.saveCandidateDetail(
        candidate: _createCandidateCompanion(
          id: candidateId,
          electionId: electionId,
          ballotName: 'TITULAR',
          roleCode: 1,
        ),
        assets: updatedAssets,
      );

      final retrieved = await dataSource.getCandidateAssets(candidateId);
      expect(retrieved.length, equals(2));
      expect(retrieved.first.amount, equals(300000.0));
    });
  });

  group('CandidateLocalDataSource - Metadados de Cache SWR', () {
    const cacheKey = '2026_BR_20322002026_1';

    test('deve salvar, consultar e atualizar lastFetchedAt', () async {
      final initial = CacheMetadataTableCompanion.insert(
        cacheKey: cacheKey,
        lastFetchedAt: '2026-09-14T01:00:00Z',
        payloadHash: 'hash_sha256_original',
        itemCount: 15,
        etag: const Value('W/"etag-123"'),
      );

      await dataSource.saveCacheMetadata(initial);

      final fetched = await dataSource.getCacheMetadata(cacheKey);
      expect(fetched, isNotNull);
      expect(fetched!.payloadHash, equals('hash_sha256_original'));
      expect(fetched.itemCount, equals(15));
      expect(fetched.etag, equals('W/"etag-123"'));

      await dataSource.updateLastFetchedAt(
        cacheKey: cacheKey,
        lastFetchedAt: '2026-09-14T02:00:00Z',
      );

      final updated = await dataSource.getCacheMetadata(cacheKey);
      expect(updated!.lastFetchedAt, equals('2026-09-14T02:00:00Z'));
      expect(updated.payloadHash, equals('hash_sha256_original'));
    });

    test('deve retornar null para cacheKey nao registrada', () async {
      final result = await dataSource.getCacheMetadata('chave_inexistente');
      expect(result, isNull);
    });
  });

  group('CandidateLocalDataSource - Tratamento Rico de Falhas (CacheException)', () {
    test(
      'deve lancar CacheException ao tentar inserir candidato com electionId inexistente',
      () async {
        final invalidCandidate = _createCandidateCompanion(
          id: 999,
          electionId: 999999999, // Inexistente
          ballotName: 'FANTASMA',
          roleCode: 1,
        );

        expect(
          () => dataSource.saveCandidates(
            electionId: 999999999,
            stateCode: 'BR',
            roleCode: 1,
            candidates: [invalidCandidate],
          ),
          throwsA(isA<CacheException>()),
        );
      },
    );
  });
}

// Helpers de Instanciacao de Companions para Testes Isolados

ElectionsTableCompanion _createElectionCompanion({
  required int id,
  required int ano,
  required String nome,
}) {
  return ElectionsTableCompanion.insert(
    id: Value(id),
    ano: ano,
    nome: nome,
    descricao: 'Descricao Oficial',
    tipo: 'Ordinaria',
    abrangencia: 'F',
    turno: 1,
    dataEleicao: '04/10/2026',
    situacao: 'Aberta',
  );
}

ElectionsCargosTableCompanion _createCargoCompanion({
  required int electionId,
  required String stateCode,
  required int cargoCode,
  required String nome,
}) {
  return ElectionsCargosTableCompanion.insert(
    electionId: electionId,
    stateCode: stateCode,
    cargoCode: cargoCode,
    cargoSigla: 'C',
    cargoNome: nome,
    titular: true,
    contagem: 10,
  );
}

CandidatesTableCompanion _createCandidateCompanion({
  required int id,
  required int electionId,
  required String ballotName,
  required int roleCode,
  int? parentCandidateId,
  bool detailFetched = false,
  String? birthDate,
  String? gender,
}) {
  return CandidatesTableCompanion(
    id: Value(id),
    electionId: Value(electionId),
    stateCode: const Value('BR'),
    cityCode: const Value(null),
    roleCode: Value(roleCode),
    roleDescription: const Value('Cargo Teste'),
    ballotNumber: const Value(10),
    ballotName: Value(ballotName),
    fullName: Value('NOME COMPLETO DE $ballotName'),
    partyNumber: const Value(10),
    partyAcronym: const Value('PART'),
    partyName: const Value('Partido Teste'),
    coalitionName: const Value('Coligacao Teste'),
    coalitionComp: const Value('PART'),
    status: const Value('DEFERRED'),
    rawStatus: const Value('Deferido'),
    totalAssets: const Value(100000.0),
    photoUrl: const Value('https://exemplo.tse.jus.br/foto.jpg'),
    parentCandidateId: Value(parentCandidateId),
    detailFetched: Value(detailFetched),
    birthDate: Value(birthDate),
    gender: Value(gender),
  );
}

CandidateAssetsTableCompanion _createAssetCompanion({
  required int candidateId,
  required int order,
  required double amount,
}) {
  return CandidateAssetsTableCompanion.insert(
    candidateId: candidateId,
    orderIndex: order,
    category: 'IMOVEL',
    description: 'Imovel residencial teste',
    amount: amount,
    updatedAt: '15/08/2026',
  );
}
