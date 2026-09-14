import 'package:drift/drift.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/errors/tse_failure_mapper.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';
import 'package:quem_votar/data/mappers/tse_asset_mapper.dart';
import 'package:quem_votar/data/mappers/tse_candidate_detail_mapper.dart';
import 'package:quem_votar/data/mappers/tse_candidate_summary_mapper.dart';
import 'package:quem_votar/data/mappers/tse_running_mate_mapper.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/repositories/tse_cache_hasher.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/repositories/candidate_repository.dart';

/// Implementacao do repositorio de dados eleitorais com politica Stale-While-Revalidate (SWR).
///
/// Orquestra a persistencia relacional local no Drift e a consulta remota ao TSE, aplicando
/// validacao de janela de frescor (TTL), deteccao de deltas por SHA-256 e contingencia offline.
class CandidateRepositoryImpl implements CandidateRepository {
  final TseRemoteDataSource _remoteDataSource;
  final CandidateLocalDataSource _localDataSource;
  final Duration _cacheTtl;

  const CandidateRepositoryImpl({
    required TseRemoteDataSource remoteDataSource,
    required CandidateLocalDataSource localDataSource,
    Duration cacheTtl = const Duration(minutes: 60),
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _cacheTtl = cacheTtl;

  @override
  Future<Result<List<CandidateSummary>, Failure>> getCandidates({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int roleCode,
    bool forceRefresh = false,
  }) async {
    final cleanUf = ufOrMun.trim().toUpperCase();
    final cacheKey = '${year}_${cleanUf}_${electionId}_$roleCode';

    final cachedList = await _checkLocalCandidates(
      electionId: electionId,
      stateCode: cleanUf,
      roleCode: roleCode,
      cacheKey: cacheKey,
      forceRefresh: forceRefresh,
    );

    if (cachedList != null) {
      return Result.success(cachedList);
    }

    return _fetchAndSyncCandidates(
      year: year,
      cleanUf: cleanUf,
      electionId: electionId,
      roleCode: roleCode,
      cacheKey: cacheKey,
    );
  }

  @override
  Future<Result<CandidateDetail, Failure>> getCandidateDetail({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int candidateId,
    bool forceRefresh = false,
  }) async {
    final cleanUf = ufOrMun.trim().toUpperCase();
    final cacheKey = '${year}_${cleanUf}_${electionId}_detail_$candidateId';

    final cachedDetail = await _checkLocalCandidateDetail(
      candidateId: candidateId,
      cacheKey: cacheKey,
      forceRefresh: forceRefresh,
    );

    if (cachedDetail != null) {
      return Result.success(cachedDetail);
    }

    return _fetchAndSyncCandidateDetail(
      year: year,
      cleanUf: cleanUf,
      electionId: electionId,
      candidateId: candidateId,
      cacheKey: cacheKey,
    );
  }

  Future<List<CandidateSummary>?> _checkLocalCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
    required String cacheKey,
    required bool forceRefresh,
  }) async {
    if (forceRefresh) return null;
    try {
      final metadata = await _localDataSource.getCacheMetadata(cacheKey);
      if (!_isCacheFresh(metadata)) return null;

      final localData = await _localDataSource.getCandidates(
        electionId: electionId,
        stateCode: stateCode,
        roleCode: roleCode,
      );
      if (localData.isEmpty) return null;

      return localData.map(TseCandidateSummaryMapper.fromData).toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  Future<Result<List<CandidateSummary>, Failure>> _fetchAndSyncCandidates({
    required int year,
    required String cleanUf,
    required int electionId,
    required int roleCode,
    required String cacheKey,
  }) async {
    try {
      final envelope = await _remoteDataSource.getCandidates(
        year: year,
        ufOrMun: cleanUf,
        electionId: electionId,
        roleCode: roleCode,
      );
      try {
        await _ensureElectionExists(electionId: electionId, year: year, stateCode: cleanUf);
        await _syncCandidateListEnvelope(
          cacheKey: cacheKey,
          envelope: envelope,
          electionId: electionId,
          stateCode: cleanUf,
          roleCode: roleCode,
        );
      } catch (_) {
        // Falha de escrita no cache local nao impede a apresentacao dos dados obtidos
      }
      final domainList = envelope.candidates
          .map(
            (dto) =>
                TseCandidateSummaryMapper.fromDto(dto, electionId: electionId, ufOrMun: cleanUf),
          )
          .toList(growable: false);
      return Result.success(domainList);
    } catch (e) {
      return _fallbackCandidates(
        electionId: electionId,
        stateCode: cleanUf,
        roleCode: roleCode,
        error: e,
        context: 'CandidateRepositoryImpl.getCandidates',
      );
    }
  }

  Future<void> _syncCandidateListEnvelope({
    required String cacheKey,
    required CandidateListEnvelopeDto envelope,
    required int electionId,
    required String stateCode,
    required int roleCode,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final newHash = TseCacheHasher.hashCandidateList(envelope);
    final currentMetadata = await _localDataSource.getCacheMetadata(cacheKey);

    if (currentMetadata != null && currentMetadata.payloadHash == newHash) {
      await _localDataSource.updateLastFetchedAt(cacheKey: cacheKey, lastFetchedAt: nowIso);
      return;
    }

    final companions = envelope.candidates
        .map(
          (dto) => TseCandidateSummaryMapper.toCompanion(
            dto,
            electionId: electionId,
            stateCode: stateCode,
          ),
        )
        .toList(growable: false);

    await _localDataSource.saveCandidates(
      electionId: electionId,
      stateCode: stateCode,
      roleCode: roleCode,
      candidates: companions,
    );

    await _localDataSource.saveCacheMetadata(
      CacheMetadataTableCompanion(
        cacheKey: Value(cacheKey),
        lastFetchedAt: Value(nowIso),
        payloadHash: Value(newHash),
        itemCount: Value(envelope.candidates.length),
      ),
    );
  }

  Future<CandidateDetail?> _checkLocalCandidateDetail({
    required int candidateId,
    required String cacheKey,
    required bool forceRefresh,
  }) async {
    if (forceRefresh) return null;
    try {
      final metadata = await _localDataSource.getCacheMetadata(cacheKey);
      if (!_isCacheFresh(metadata)) return null;

      final record = await _localDataSource.getCandidateDetailRecord(candidateId);
      if (record == null || !record.candidate.detailFetched) return null;

      return TseCandidateDetailMapper.fromDatabase(
        candidate: record.candidate,
        assets: record.assets,
        runningMates: record.runningMates,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Result<CandidateDetail, Failure>> _fetchAndSyncCandidateDetail({
    required int year,
    required String cleanUf,
    required int electionId,
    required int candidateId,
    required String cacheKey,
  }) async {
    try {
      final detailDto = await _remoteDataSource.getCandidateDetail(
        year: year,
        ufOrMun: cleanUf,
        electionId: electionId,
        candidateId: candidateId,
      );

      try {
        await _ensureElectionExists(electionId: electionId, year: year, stateCode: cleanUf);
        await _syncCandidateDetailRecord(
          cacheKey: cacheKey,
          detailDto: detailDto,
          electionId: electionId,
          stateCode: cleanUf,
        );
      } catch (_) {
        // Falha nao-fatal de sincronizacao de cache local
      }

      return Result.success(
        TseCandidateDetailMapper.fromDto(detailDto, electionId: electionId, ufOrMun: cleanUf),
      );
    } catch (e) {
      return _fallbackCandidateDetail(
        candidateId: candidateId,
        error: e,
        context: 'CandidateRepositoryImpl.getCandidateDetail',
      );
    }
  }

  Future<void> _syncCandidateDetailRecord({
    required String cacheKey,
    required CandidateDetailDto detailDto,
    required int electionId,
    required String stateCode,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final newHash = TseCacheHasher.hashCandidateDetail(detailDto);
    final currentMetadata = await _localDataSource.getCacheMetadata(cacheKey);

    if (currentMetadata != null && currentMetadata.payloadHash == newHash) {
      await _localDataSource.updateLastFetchedAt(cacheKey: cacheKey, lastFetchedAt: nowIso);
      return;
    }

    final candidate = TseCandidateDetailMapper.toCompanion(
      detailDto,
      electionId: electionId,
      stateCode: stateCode,
    );
    final assets = detailDto.assets
        .map((a) => TseAssetMapper.toCompanion(a, candidateId: detailDto.id))
        .toList(growable: false);
    final mates = detailDto.runningMates
        .map(
          (m) => TseRunningMateMapper.toCompanion(m, electionId: electionId, stateCode: stateCode),
        )
        .toList(growable: false);

    await _localDataSource.saveCandidateDetail(
      candidate: candidate,
      assets: assets,
      runningMates: mates,
    );

    await _localDataSource.saveCacheMetadata(
      CacheMetadataTableCompanion(
        cacheKey: Value(cacheKey),
        lastFetchedAt: Value(nowIso),
        payloadHash: Value(newHash),
        itemCount: Value(1 + assets.length + mates.length),
      ),
    );
  }

  Future<Result<List<CandidateSummary>, Failure>> _fallbackCandidates({
    required int electionId,
    required String stateCode,
    required int roleCode,
    required Object error,
    required String context,
  }) async {
    try {
      final local = await _localDataSource.getCandidates(
        electionId: electionId,
        stateCode: stateCode,
        roleCode: roleCode,
      );
      if (local.isNotEmpty) {
        return Result.success(
          local.map(TseCandidateSummaryMapper.fromData).toList(growable: false),
        );
      }
    } catch (_) {
      // Ignora falha de leitura local para reportar falha original
    }
    return Result.failure(TseFailureMapper.map(error, operationalContext: context));
  }

  Future<Result<CandidateDetail, Failure>> _fallbackCandidateDetail({
    required int candidateId,
    required Object error,
    required String context,
  }) async {
    try {
      final record = await _localDataSource.getCandidateDetailRecord(candidateId);
      if (record != null && record.candidate.detailFetched) {
        return Result.success(
          TseCandidateDetailMapper.fromDatabase(
            candidate: record.candidate,
            assets: record.assets,
            runningMates: record.runningMates,
          ),
        );
      }
    } catch (_) {
      // Ignora falha de leitura local para reportar falha original
    }
    return Result.failure(TseFailureMapper.map(error, operationalContext: context));
  }

  bool _isCacheFresh(CacheMetadataData? metadata) {
    if (metadata == null) return false;
    final lastFetched = DateTime.tryParse(metadata.lastFetchedAt);
    if (lastFetched == null) return false;
    final age = DateTime.now().toUtc().difference(lastFetched);
    return age < _cacheTtl;
  }

  Future<void> _ensureElectionExists({
    required int electionId,
    required int year,
    required String stateCode,
  }) async {
    final existing = await _localDataSource.getElectionById(electionId);
    if (existing != null) return;

    await _localDataSource.saveElections([
      ElectionsTableCompanion.insert(
        id: Value(electionId),
        ano: year,
        nome: 'Eleicoes $year',
        descricao: 'Pleito Eleitoral Oficial $year',
        tipo: 'Ordinaria',
        abrangencia: stateCode,
        turno: 1,
        dataEleicao: '$year-10-04',
        situacao: 'Oficial',
      ),
    ]);
  }
}
