import 'package:drift/drift.dart';

/// Tabela de gestao de metadados para a politica de cache Stale-While-Revalidate (SWR).
///
/// Mapeada para 'cache_metadata', armazenando hashes SHA-256 e carimbos temporais
/// para deteccao de deltas e validacao de integridade de payloads governamentais.
@DataClassName('CacheMetadataData')
class CacheMetadataTable extends Table {
  @override
  String get tableName => 'cache_metadata';

  /// Chave composta de consulta no formato {ano}_{uf}_{idEleicao}_{codigoCargo}.
  TextColumn get cacheKey => text().named('cache_key')();

  /// Carimbo ISO-8601 correspondente a ultima captura remota bem-sucedida.
  TextColumn get lastFetchedAt => text().named('last_fetched_at')();

  /// Hash criptografico SHA-256 calculado sobre o payload bruto recebido da API.
  TextColumn get payloadHash => text().named('payload_hash')();

  /// Cabecalho ETag HTTP emitido pelo servidor perimetral governamental.
  TextColumn get etag => text().named('etag').nullable()();

  /// Total de registros consolidados obtidos na resposta oficial correspondente.
  IntColumn get itemCount => integer().named('item_count')();

  @override
  Set<Column> get primaryKey => {cacheKey};
}
