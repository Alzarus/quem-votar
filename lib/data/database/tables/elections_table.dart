import 'package:drift/drift.dart';

/// Tabela responsavel pela persistencia dos metadados de pleitos oficiais do TSE.
///
/// Mapeada para a tabela relacional 'elections'. O identificador 'id' e o codigo
/// oficial do pleito (ex: 20322002026), prescindindo de auto-incremento.
@DataClassName('ElectionData')
class ElectionsTable extends Table {
  @override
  String get tableName => 'elections';

  /// Identificador unico do pleito no sistema DivulgaCandContas do TSE.
  IntColumn get id => integer()();

  /// Ano eleitoral de realizacao do pleito (ex: 2026).
  IntColumn get ano => integer()();

  /// Nome oficial da eleicao (ex: 'Eleicao Geral Federal 2026').
  TextColumn get nome => text()();

  /// Descricao detalhada divulgada pelo TSE.
  TextColumn get descricao => text()();

  /// Classificacao do pleito: 'Ordinaria' ou 'Suplementar'.
  TextColumn get tipo => text()();

  /// Abrangencia territorial: 'F' (Federal), 'E' (Estadual) ou 'M' (Municipal).
  TextColumn get abrangencia => text()();

  /// Turno de votacao (1 ou 2).
  IntColumn get turno => integer()();

  /// Data oficial da votacao no formato dd/MM/yyyy.
  TextColumn get dataEleicao => text().named('data_eleicao')();

  /// Situacao do pleito registrada na Justica Eleitoral.
  TextColumn get situacao => text()();

  @override
  Set<Column> get primaryKey => {id};
}
