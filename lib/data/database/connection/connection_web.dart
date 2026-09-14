import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

/// Fabrica de conexao SQLite Web via WebAssembly para persistencia em sandbox de navegador.
///
/// Utiliza WasmDatabase.open com fallback transparente para in-memory caso o web worker
/// encontre restricoes de ambiente ou timeout de inicializacao.
QueryExecutor openConnection({bool logStatements = false}) {
  return LazyDatabase(() async {
    final sqliteUri = Uri.base.resolve('sqlite3.wasm');
    final workerUri = Uri.base.resolve('drift_worker.js');

    try {
      final result = await WasmDatabase.open(
        databaseName: 'quem_votar_db',
        sqlite3Uri: sqliteUri,
        driftWorkerUri: workerUri,
      ).timeout(const Duration(seconds: 3));
      return result.resolvedExecutor;
    } catch (_) {
      final sqlite = await WasmSqlite3.loadFromUrl(sqliteUri);
      return WasmDatabase.inMemory(sqlite);
    }
  });
}
