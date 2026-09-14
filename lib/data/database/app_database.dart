import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/connection/connection.dart' as impl;
import 'package:quem_votar/data/database/tables/cache_metadata_table.dart';
import 'package:quem_votar/data/database/tables/candidate_assets_table.dart';
import 'package:quem_votar/data/database/tables/candidates_table.dart';
import 'package:quem_votar/data/database/tables/elections_cargos_table.dart';
import 'package:quem_votar/data/database/tables/elections_table.dart';

part 'app_database.g.dart';

/// Banco de dados relacional local do aplicativo Quem Votar gerenciado pelo Drift.
///
/// Encapsula as cinco tabelas oficiais do sistema, provendo metodos de consulta,
/// streams reativos e integridade referencial compulsoria via chaves estrangeiras SQLite.
@DriftDatabase(
  tables: [
    ElectionsTable,
    ElectionsCargosTable,
    CandidatesTable,
    CandidateAssetsTable,
    CacheMetadataTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Instancia o banco utilizando o executor da plataforma ou um customizado (ex: testes em memoria).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? impl.openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}
