import 'package:drift/drift.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/errors/tse_failure_mapper.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';
import 'package:quem_votar/data/mappers/tse_election_mapper.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/data/repositories/tse_cache_hasher.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/repositories/election_repository.dart';

/// Implementacao do repositorio de pleitos eleitorais oficiais com cache SWR.
///
/// Recupera eleicoes ordinarias do TSE e sincroniza a tabela local do Drift com deteccao por hash.
class ElectionRepositoryImpl implements ElectionRepository {
  static const String _cacheKey = 'eleicoes_ordinarias';

  final TseRemoteDataSource _remoteDataSource;
  final CandidateLocalDataSource _localDataSource;
  final Duration _cacheTtl;

  const ElectionRepositoryImpl({
    required TseRemoteDataSource remoteDataSource,
    required CandidateLocalDataSource localDataSource,
    Duration cacheTtl = const Duration(hours: 24),
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _cacheTtl = cacheTtl;

  @override
  Future<Result<List<Election>, Failure>> getElections() async {
    final cachedList = await _checkLocalElections();
    if (cachedList != null) {
      return Result.success(cachedList);
    }

    return _fetchAndSyncElections();
  }

  Future<List<Election>?> _checkLocalElections() async {
    try {
      final metadata = await _localDataSource.getCacheMetadata(_cacheKey);
      if (!_isCacheFresh(metadata)) return null;

      final localData = await _localDataSource.getElections();
      if (localData.isEmpty) return null;

      return localData.map(TseElectionMapper.fromData).toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  Future<Result<List<Election>, Failure>> _fetchAndSyncElections() async {
    try {
      final remoteList = await _remoteDataSource.getOrdinarias();
      try {
        await _syncElections(remoteList);
      } catch (_) {
        // Falha nao-fatal de escrita no cache local
      }
      final domainList = remoteList.map(TseElectionMapper.fromDto).toList(growable: false);
      return Result.success(domainList);
    } catch (e) {
      return _fallbackElections(e, 'ElectionRepositoryImpl.getElections');
    }
  }

  Future<void> _syncElections(List<ElectionDto> elections) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final newHash = TseCacheHasher.hashElections(elections);
    final currentMetadata = await _localDataSource.getCacheMetadata(_cacheKey);

    if (currentMetadata != null && currentMetadata.payloadHash == newHash) {
      await _localDataSource.updateLastFetchedAt(cacheKey: _cacheKey, lastFetchedAt: nowIso);
      return;
    }

    final companions = elections.map(TseElectionMapper.toCompanion).toList(growable: false);
    await _localDataSource.saveElections(companions);

    await _localDataSource.saveCacheMetadata(
      CacheMetadataTableCompanion(
        cacheKey: const Value(_cacheKey),
        lastFetchedAt: Value(nowIso),
        payloadHash: Value(newHash),
        itemCount: Value(elections.length),
      ),
    );
  }

  Future<Result<List<Election>, Failure>> _fallbackElections(Object error, String context) async {
    try {
      final local = await _localDataSource.getElections();
      if (local.isNotEmpty) {
        return Result.success(local.map(TseElectionMapper.fromData).toList(growable: false));
      }
    } catch (_) {
      // Ignora erro de leitura local
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
}
