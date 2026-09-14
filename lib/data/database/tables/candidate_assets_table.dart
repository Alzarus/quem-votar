import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/tables/candidates_table.dart';

/// Tabela responsavel pela discriminacao individualizada dos bens patrimoniais declarados.
///
/// Mapeada para 'candidate_assets', indexada para ordenacao rapida por valor venal decrescente.
@DataClassName('CandidateAssetData')
@TableIndex(
  name: 'idx_assets_candidate',
  columns: {
    #candidateId,
    IndexedColumn(#amount, orderBy: OrderingMode.desc),
  },
)
class CandidateAssetsTable extends Table {
  @override
  String get tableName => 'candidate_assets';

  /// Identificador sintetico local autoincrementavel.
  IntColumn get id => integer().autoIncrement()();

  /// Chave estrangeira vinculando o bem ao candidato titular.
  IntColumn get candidateId => integer().named('candidate_id').references(CandidatesTable, #id)();

  /// Indice sequencial de apresentacao fornecido originalmente pelo TSE.
  IntColumn get orderIndex => integer().named('order_index')();

  /// Categoria ou tipo padronizado do bem (ex: 'VEICULO AUTOMOTOR', 'APARTAMENTO').
  TextColumn get category => text().named('category')();

  /// Descricao detalhada do bem prestada pelo candidato a Justica Eleitoral.
  TextColumn get description => text().named('description')();

  /// Valor venal em moeda corrente nacional com precisao centesimal.
  RealColumn get amount => real().named('amount')();

  /// Carimbo temporal da ultima atualizacao do registro patrimonial.
  TextColumn get updatedAt => text().named('updated_at')();
}
