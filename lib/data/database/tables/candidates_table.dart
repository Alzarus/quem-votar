import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/tables/elections_table.dart';

/// Tabela unificada para persistencia de dados cadastrais e detalhados de candidaturas.
///
/// Unifica os dados basicos da listagem oficial com os atributos aprofundados
/// obtidos sob demanda no endpoint individual, em conformidade com a decisao D03.
@DataClassName('CandidateData')
@TableIndex(name: 'idx_candidates_query', columns: {#electionId, #stateCode, #roleCode})
@TableIndex(name: 'idx_candidates_party', columns: {#electionId, #partyNumber})
@TableIndex(name: 'idx_candidates_search', columns: {#ballotName, #fullName, #ballotNumber})
@TableIndex(name: 'idx_candidates_parent', columns: {#parentCandidateId})
class CandidatesTable extends Table {
  @override
  String get tableName => 'candidates';

  /// Identificador sequencial unico do candidato no TSE (chave primaria oficial).
  IntColumn get id => integer()();

  /// Chave estrangeira referenciando o pleito eleitoral correspondente.
  IntColumn get electionId => integer().named('election_id').references(ElectionsTable, #id)();

  /// Sigla da Unidade Federativa da candidatura ou 'BR' para pleito nacional.
  TextColumn get stateCode => text().named('state_code')();

  /// Codigo do municipio no TSE (nulo para cargos federais ou estaduais).
  IntColumn get cityCode => integer().named('city_code').nullable()();

  /// Codigo oficial do cargo pleiteado no TSE (1 a 13).
  IntColumn get roleCode => integer().named('role_code')();

  /// Descricao oficial do cargo no TSE.
  TextColumn get roleDescription => text().named('role_description')();

  /// Numero do candidato na urna eleitoral.
  IntColumn get ballotNumber => integer().named('ballot_number')();

  /// Nome do candidato registrado para exibicao em tela de votacao.
  TextColumn get ballotName => text().named('ballot_name')();

  /// Nome completo de registro civil.
  TextColumn get fullName => text().named('full_name')();

  /// Numero da legenda partidaria oficial.
  IntColumn get partyNumber => integer().named('party_number')();

  /// Sigla oficial da agremiacao partidaria.
  TextColumn get partyAcronym => text().named('party_acronym')();

  /// Denominacao completa do partido politico.
  TextColumn get partyName => text().named('party_name')();

  /// Nome da coligacao ou federacao partidaria registrada.
  TextColumn get coalitionName => text().named('coalition_name')();

  /// Composicao detalhada das siglas participantes da coligacao.
  TextColumn get coalitionComp => text().named('coalition_comp')();

  /// Status normalizado de registro de candidatura (ex: 'DEFERRED', 'CANCELED').
  TextColumn get status => text().named('status')();

  /// Status literal bruto retornado pela API do TSE (ex: 'DEFERIDO COM RECURSO').
  TextColumn get rawStatus => text().named('raw_status')();

  /// Valor venal total declarado de bens em moeda corrente nacional.
  RealColumn get totalAssets => real().named('total_assets')();

  /// Endereco URL oficial da imagem fotografica no servidor do TSE.
  TextColumn get photoUrl => text().named('photo_url')();

  /// Caminho relativo ou absoluto do arquivo de fotografia persistido em cache local.
  TextColumn get localPhotoPath => text().named('local_photo_path').nullable()();

  /// Chave auto-referencial indicando vinculo com titular (para vices ou suplentes).
  IntColumn get parentCandidateId =>
      integer().named('parent_candidate_id').nullable().references(CandidatesTable, #id)();

  /// Data de nascimento informada a Justica Eleitoral no formato dd/MM/yyyy.
  TextColumn get birthDate => text().named('birth_date').nullable()();

  /// Genero declarado pelo candidato.
  TextColumn get gender => text().named('gender').nullable()();

  /// Autodeclaracao etnico-racial registrada no TSE.
  TextColumn get colorRace => text().named('color_race').nullable()();

  /// Estado civil informado no registro de candidatura.
  TextColumn get maritalStatus => text().named('marital_status').nullable()();

  /// Grau de instrucao formal declarado.
  TextColumn get educationLevel => text().named('education_level').nullable()();

  /// Ocupacao profissional principal declarada.
  TextColumn get occupation => text().named('occupation').nullable()();

  /// Nacionalidade informada no registro.
  TextColumn get nationality => text().named('nationality').nullable()();

  /// Municipio de naturalidade do candidato.
  TextColumn get birthCity => text().named('birth_city').nullable()();

  /// Unidade Federativa de nascimento.
  TextColumn get birthState => text().named('birth_state').nullable()();

  /// Teto legal autorizado de gastos de campanha para o primeiro turno.
  RealColumn get maxExpense1t => real().named('max_expense_1t').nullable()();

  /// Teto legal autorizado de gastos de campanha para o segundo turno.
  RealColumn get maxExpense2t => real().named('max_expense_2t').nullable()();

  /// Endereco URL de download do plano/proposta de governo protocolado.
  TextColumn get proposalDocUrl => text().named('proposal_doc_url').nullable()();

  /// Cadastro Nacional da Pessoa Juridica (CNPJ) oficial da conta de campanha.
  TextColumn get campaignCnpj => text().named('campaign_cnpj').nullable()();

  /// Flag indicadora de captura previa dos metadados aprofundados de detalhe.
  BoolColumn get detailFetched =>
      boolean().named('detail_fetched').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
