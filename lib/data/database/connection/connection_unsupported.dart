import 'package:drift/drift.dart';

/// Fabrica de contingencia para plataformas que nao suportam SQLite nem WebAssembly.
QueryExecutor openConnection({bool logStatements = false}) {
  throw UnsupportedError(
    'Plataforma nao suportada para conexao direta do banco de dados relacional.',
  );
}
