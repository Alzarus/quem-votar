import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Fabrica de conexao SQLite Web via WebAssembly para persistencia em sandbox de navegador.
///
/// Utiliza WasmDatabase.open com fallback transparente entre OPFS e IndexedDB.
QueryExecutor openConnection({bool logStatements = false}) {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'quem_votar_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
