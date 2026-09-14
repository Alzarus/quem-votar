import 'package:drift/drift.dart';
import 'package:quem_votar/core/errors/exceptions.dart';
import 'package:quem_votar/data/database/app_database.dart';

/// Registro composto imutavel para agregacao da ficha cadastral de candidatos.
///
/// Encapsula os dados do titular ([CandidateData]), os bens declarados ([CandidateAssetData])
/// e os integrantes de chapa vinculados ([CandidateData]), viabilizando transformacao direta
/// para a entidade de dominio CandidateDetail via mappers.
class CandidateDetailRecord {
  /// Registro unificado do candidato com campos de listagem e atributos detalhados.
  final CandidateData candidate;

  /// Relacao ordenada de bens patrimoniais declarados a Justica Eleitoral.
  final List<CandidateAssetData> assets;

  /// Integrantes de chapa (vice-candidatos ou suplentes) associados ao titular.
  final List<CandidateData> runningMates;

  const CandidateDetailRecord({
    required this.candidate,
    required this.assets,
    required this.runningMates,
  });
}

/// Contrato da fonte de dados relacional local baseada no Drift (SQLite).
///
/// Gerencia a persistencia de pleitos, cargos, candidaturas, bens patrimoniais e
/// metadados de cache SWR com suporte a operacoes transacionais e streams reativas.
abstract interface class CandidateLocalDataSource {
  /// Persiste ou atualiza lista de pleitos eleitorais oficiais.
  Future<void> saveElections(List<ElectionsTableCompanion> elections);

  /// Recupera todos os pleitos eleitorais gravados ordenados por ano decrescente.
  Future<List<ElectionData>> getElections();

  /// Emite stream reativo de pleitos eleitorais ordenados por ano decrescente.
  Stream<List<ElectionData>> watchElections();

  /// Consulta um pleito eleitoral especifico por seu identificador oficial.
  Future<ElectionData?> getElectionById(int electionId);

  /// Grava cargos disputados em uma eleicao e UF, substituindo registros anteriores.
  Future<void> saveCargos({
    required int electionId,
    required String stateCode,
    required List<ElectionsCargosTableCompanion> cargos,
  });

  /// Recupera cargos disputados para uma eleicao e UF ordenados por codigo de cargo.
  Future<List<ElectionCargoData>> getCargos({required int electionId, required String stateCode});

  /// Persiste candidaturas de determinado pleito/cargo preservando flags de detalhe.
  Future<void> saveCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
    required List<CandidatesTableCompanion> candidates,
    List<CandidatesTableCompanion> runningMates = const [],
  });

  /// Consulta candidatos concorrentes ordenados alfabeticamente por nome de urna.
  Future<List<CandidateData>> getCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
  });

  /// Emite stream reativo de candidatos para acompanhamento em tempo real.
  Stream<List<CandidateData>> watchCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
  });

  /// Persiste atributos detalhados, substituindo bens e atualizando integrantes de chapa.
  Future<void> saveCandidateDetail({
    required CandidatesTableCompanion candidate,
    required List<CandidateAssetsTableCompanion> assets,
    List<CandidatesTableCompanion> runningMates = const [],
  });

  /// Consulta os dados cadastrais de um candidato individual por seu identificador.
  Future<CandidateData?> getCandidateById(int candidateId);

  /// Consulta a relacao de bens declarados por um candidato ordenados por valor venal.
  Future<List<CandidateAssetData>> getCandidateAssets(int candidateId);

  /// Consulta os integrantes de chapa vinculados a um titular.
  Future<List<CandidateData>> getRunningMates(int parentCandidateId);

  /// Recupera a ficha consolidada (titular, bens e vices) em um unico registro.
  Future<CandidateDetailRecord?> getCandidateDetailRecord(int candidateId);

  /// Grava ou atualiza os metadados de controle de integridade de cache SWR.
  Future<void> saveCacheMetadata(CacheMetadataTableCompanion metadata);

  /// Consulta metadados de cache para uma chave composta especifica.
  Future<CacheMetadataData?> getCacheMetadata(String cacheKey);

  /// Atualiza o carimbo temporal da ultima validacao de frescor de cache.
  Future<void> updateLastFetchedAt({required String cacheKey, required String lastFetchedAt});
}

/// Implementacao concreta da fonte local relacional operando sobre o [AppDatabase].
class CandidateLocalDataSourceImpl implements CandidateLocalDataSource {
  final AppDatabase _db;

  const CandidateLocalDataSourceImpl({required AppDatabase db}) : _db = db;

  @override
  Future<void> saveElections(List<ElectionsTableCompanion> elections) async {
    const context = 'CandidateLocalDataSource.saveElections';
    if (elections.isEmpty) return;
    try {
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.electionsTable, elections);
      });
    } catch (e) {
      throw CacheException(
        message: 'Falha ao gravar pleitos eleitorais no banco local: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<List<ElectionData>> getElections() async {
    const context = 'CandidateLocalDataSource.getElections';
    try {
      return await (_db.select(
        _db.electionsTable,
      )..orderBy([(tbl) => OrderingTerm.desc(tbl.ano)])).get();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar pleitos eleitorais locais: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Stream<List<ElectionData>> watchElections() {
    return (_db.select(_db.electionsTable)..orderBy([(tbl) => OrderingTerm.desc(tbl.ano)])).watch();
  }

  @override
  Future<ElectionData?> getElectionById(int electionId) async {
    const context = 'CandidateLocalDataSource.getElectionById';
    try {
      return await (_db.select(
        _db.electionsTable,
      )..where((tbl) => tbl.id.equals(electionId))).getSingleOrNull();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao buscar pleito eleitoral $electionId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<void> saveCargos({
    required int electionId,
    required String stateCode,
    required List<ElectionsCargosTableCompanion> cargos,
  }) async {
    const context = 'CandidateLocalDataSource.saveCargos';
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.electionsCargosTable)
              ..where((tbl) => tbl.electionId.equals(electionId) & tbl.stateCode.equals(stateCode)))
            .go();
        if (cargos.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(_db.electionsCargosTable, cargos);
          });
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Falha ao gravar cargos para $stateCode na eleicao $electionId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<List<ElectionCargoData>> getCargos({
    required int electionId,
    required String stateCode,
  }) async {
    const context = 'CandidateLocalDataSource.getCargos';
    try {
      return await (_db.select(_db.electionsCargosTable)
            ..where((tbl) => tbl.electionId.equals(electionId) & tbl.stateCode.equals(stateCode))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.cargoCode)]))
          .get();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar cargos para $stateCode na eleicao $electionId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<void> saveCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
    required List<CandidatesTableCompanion> candidates,
    List<CandidatesTableCompanion> runningMates = const [],
  }) async {
    const context = 'CandidateLocalDataSource.saveCandidates';
    try {
      final sanitized = await _preserveDetailFetchedFlags(candidates);
      await _db.transaction(() async {
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(_db.candidatesTable, sanitized);
        });
        if (runningMates.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAllOnConflictUpdate(_db.candidatesTable, runningMates);
          });
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Falha ao persistir candidatos da eleicao $electionId, cargo $roleCode: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<List<CandidateData>> getCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
  }) async {
    const context = 'CandidateLocalDataSource.getCandidates';
    try {
      return await (_db.select(_db.candidatesTable)
            ..where(
              (tbl) =>
                  tbl.electionId.equals(electionId) &
                  tbl.stateCode.equals(stateCode) &
                  tbl.roleCode.equals(roleCode) &
                  tbl.parentCandidateId.isNull(),
            )
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.ballotName)]))
          .get();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao buscar candidatos para $stateCode, cargo $roleCode: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Stream<List<CandidateData>> watchCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
  }) {
    return (_db.select(_db.candidatesTable)
          ..where(
            (tbl) =>
                tbl.electionId.equals(electionId) &
                tbl.stateCode.equals(stateCode) &
                tbl.roleCode.equals(roleCode) &
                tbl.parentCandidateId.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.ballotName)]))
        .watch();
  }

  @override
  Future<void> saveCandidateDetail({
    required CandidatesTableCompanion candidate,
    required List<CandidateAssetsTableCompanion> assets,
    List<CandidatesTableCompanion> runningMates = const [],
  }) async {
    const context = 'CandidateLocalDataSource.saveCandidateDetail';
    final candidateId = candidate.id.value;
    try {
      await _db.transaction(() async {
        await _db.into(_db.candidatesTable).insertOnConflictUpdate(candidate);
        await (_db.delete(
          _db.candidateAssetsTable,
        )..where((tbl) => tbl.candidateId.equals(candidateId))).go();
        if (assets.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(_db.candidateAssetsTable, assets);
          });
        }
        if (runningMates.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAllOnConflictUpdate(_db.candidatesTable, runningMates);
          });
        }
      });
    } catch (e) {
      throw CacheException(
        message: 'Falha ao persistir detalhes do candidato $candidateId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CandidateData?> getCandidateById(int candidateId) async {
    const context = 'CandidateLocalDataSource.getCandidateById';
    try {
      return await (_db.select(
        _db.candidatesTable,
      )..where((tbl) => tbl.id.equals(candidateId))).getSingleOrNull();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar candidato por id $candidateId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<List<CandidateAssetData>> getCandidateAssets(int candidateId) async {
    const context = 'CandidateLocalDataSource.getCandidateAssets';
    try {
      return await (_db.select(_db.candidateAssetsTable)
            ..where((tbl) => tbl.candidateId.equals(candidateId))
            ..orderBy([
              (tbl) => OrderingTerm.desc(tbl.amount),
              (tbl) => OrderingTerm.asc(tbl.orderIndex),
            ]))
          .get();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar bens do candidato $candidateId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<List<CandidateData>> getRunningMates(int parentCandidateId) async {
    const context = 'CandidateLocalDataSource.getRunningMates';
    try {
      return await (_db.select(
        _db.candidatesTable,
      )..where((tbl) => tbl.parentCandidateId.equals(parentCandidateId))).get();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar integrantes de chapa do titular $parentCandidateId: $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CandidateDetailRecord?> getCandidateDetailRecord(int candidateId) async {
    final candidate = await getCandidateById(candidateId);
    if (candidate == null) return null;

    final assets = await getCandidateAssets(candidateId);
    final runningMates = await getRunningMates(candidateId);

    return CandidateDetailRecord(candidate: candidate, assets: assets, runningMates: runningMates);
  }

  @override
  Future<void> saveCacheMetadata(CacheMetadataTableCompanion metadata) async {
    const context = 'CandidateLocalDataSource.saveCacheMetadata';
    try {
      await _db.into(_db.cacheMetadataTable).insertOnConflictUpdate(metadata);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao gravar metadados de cache (${metadata.cacheKey.value}): $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<CacheMetadataData?> getCacheMetadata(String cacheKey) async {
    const context = 'CandidateLocalDataSource.getCacheMetadata';
    try {
      return await (_db.select(
        _db.cacheMetadataTable,
      )..where((tbl) => tbl.cacheKey.equals(cacheKey))).getSingleOrNull();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao consultar metadados de cache ($cacheKey): $e',
        operationalContext: context,
      );
    }
  }

  @override
  Future<void> updateLastFetchedAt({
    required String cacheKey,
    required String lastFetchedAt,
  }) async {
    const context = 'CandidateLocalDataSource.updateLastFetchedAt';
    try {
      await (_db.update(_db.cacheMetadataTable)..where((tbl) => tbl.cacheKey.equals(cacheKey)))
          .write(CacheMetadataTableCompanion(lastFetchedAt: Value(lastFetchedAt)));
    } catch (e) {
      throw CacheException(
        message: 'Falha ao atualizar timestamp de cache ($cacheKey): $e',
        operationalContext: context,
      );
    }
  }

  Future<List<CandidatesTableCompanion>> _preserveDetailFetchedFlags(
    List<CandidatesTableCompanion> incoming,
  ) async {
    if (incoming.isEmpty) return const [];
    final alreadyFetchedRows =
        await (_db.selectOnly(_db.candidatesTable)
              ..addColumns([_db.candidatesTable.id])
              ..where(_db.candidatesTable.detailFetched.equals(true)))
            .map((row) => row.read(_db.candidatesTable.id)!)
            .get();
    if (alreadyFetchedRows.isEmpty) return incoming;
    final fetchedIds = alreadyFetchedRows.toSet();
    return incoming
        .map((c) {
          if (fetchedIds.contains(c.id.value)) {
            return c.copyWith(detailFetched: const Value(true));
          }
          return c;
        })
        .toList(growable: false);
  }
}
