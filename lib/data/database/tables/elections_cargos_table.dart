import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/tables/elections_table.dart';

/// Tabela responsavel pela persistencia de cargos eletivos associados a pleitos e UFs.
///
/// Mapeada para 'elections_cargos', contendo indice composto para consulta rapida.
@DataClassName('ElectionCargoData')
@TableIndex(name: 'idx_cargos_query', columns: {#electionId, #stateCode})
class ElectionsCargosTable extends Table {
  @override
  String get tableName => 'elections_cargos';

  /// Identificador sintetico local autoincrementavel.
  IntColumn get id => integer().autoIncrement()();

  /// Chave estrangeira vinculando o cargo ao pleito oficial.
  IntColumn get electionId => integer().named('election_id').references(ElectionsTable, #id)();

  /// Sigla da Unidade Federativa ('SP', 'BA', etc.) ou 'BR' para cargos federais.
  TextColumn get stateCode => text().named('state_code')();

  /// Codigo oficial do cargo no TSE (1 a 13).
  IntColumn get cargoCode => integer().named('cargo_code')();

  /// Sigla padronizada do cargo (ex: 'P', 'VP', 'GE', 'S').
  TextColumn get cargoSigla => text().named('cargo_sigla')();

  /// Denominacao completa do cargo.
  TextColumn get cargoNome => text().named('cargo_nome')();

  /// Indicador booleano de cargo titular (verdadeiro para titular, falso para vice/suplente).
  BoolColumn get titular => boolean().named('titular')();

  /// Quantidade total de candidaturas registradas para este cargo e jurisdicao.
  IntColumn get contagem => integer().named('contagem')();
}
