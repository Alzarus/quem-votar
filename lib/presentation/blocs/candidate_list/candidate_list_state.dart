import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';

/// Ciclo de vida da recuperacao da lista de candidaturas.
enum CandidateListStatus { initial, loading, success, failure }

/// Criterios de ordenacao permitidos em conformidade com RNF03 (Neutralidade Estrita).
enum CandidateSortOption {
  alphabetical('Nome de Urna (A-Z)'),
  ballotNumber('Numero Eleitoral'),
  party('Partido / Federacao');

  final String label;
  const CandidateSortOption(this.label);
}

/// Filtros de aptidao juridica para recepcao de votos validos.
enum CandidateStatusFilter {
  all('Todas as Situações'),
  eligibleOnly('Apenas Aptos a Voto'),
  subJudiceOnly('Sub Judice / Em Recurso');

  final String label;
  const CandidateStatusFilter(this.label);
}

/// Faixas de patrimonio declarado oficial perante o TSE.
enum CandidateAssetsFilter {
  all('Todos os Patrimônios'),
  none('Sem Bens Declarados'),
  upTo200k('Até R\$ 200 mil'),
  from200kTo1M('R\$ 200 mil a R\$ 1 milhão'),
  above1M('Acima de R\$ 1 milhão');

  final String label;
  const CandidateAssetsFilter(this.label);
}

/// Estado imutavel para o fluxo de listagem e filtragem de candidatos.
class CandidateListState extends Equatable {
  final CandidateListStatus status;
  final List<CandidateSummary> allCandidates;
  final List<CandidateSummary> filteredCandidates;
  final String searchQuery;
  final String? selectedParty;
  final CandidateStatusFilter statusFilter;
  final CandidateAssetsFilter assetsFilter;
  final CandidateSortOption sortOption;
  final Failure? failure;
  final bool isRefreshing;

  // Parametros ativos de consulta eleitoral
  final int? activeYear;
  final String? activeUfOrMun;
  final int? activeElectionId;
  final int? activeRoleCode;

  const CandidateListState({
    required this.status,
    required this.allCandidates,
    required this.filteredCandidates,
    required this.searchQuery,
    this.selectedParty,
    this.statusFilter = CandidateStatusFilter.all,
    this.assetsFilter = CandidateAssetsFilter.all,
    required this.sortOption,
    this.failure,
    this.isRefreshing = false,
    this.activeYear,
    this.activeUfOrMun,
    this.activeElectionId,
    this.activeRoleCode,
  });

  /// Construtor de fabrica para o estado inicial neutro.
  factory CandidateListState.initial() => const CandidateListState(
    status: CandidateListStatus.initial,
    allCandidates: [],
    filteredCandidates: [],
    searchQuery: '',
    selectedParty: null,
    statusFilter: CandidateStatusFilter.all,
    assetsFilter: CandidateAssetsFilter.all,
    sortOption: CandidateSortOption.alphabetical,
    failure: null,
    isRefreshing: false,
  );

  /// Cria copia imutavel com substituicao parametrica segura.
  CandidateListState copyWith({
    CandidateListStatus? status,
    List<CandidateSummary>? allCandidates,
    List<CandidateSummary>? filteredCandidates,
    String? searchQuery,
    String? Function()? selectedParty,
    CandidateStatusFilter? statusFilter,
    CandidateAssetsFilter? assetsFilter,
    CandidateSortOption? sortOption,
    Failure? Function()? failure,
    bool? isRefreshing,
    int? activeYear,
    String? activeUfOrMun,
    int? activeElectionId,
    int? activeRoleCode,
  }) {
    return CandidateListState(
      status: status ?? this.status,
      allCandidates: allCandidates ?? this.allCandidates,
      filteredCandidates: filteredCandidates ?? this.filteredCandidates,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedParty: selectedParty != null ? selectedParty() : this.selectedParty,
      statusFilter: statusFilter ?? this.statusFilter,
      assetsFilter: assetsFilter ?? this.assetsFilter,
      sortOption: sortOption ?? this.sortOption,
      failure: failure != null ? failure() : this.failure,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeYear: activeYear ?? this.activeYear,
      activeUfOrMun: activeUfOrMun ?? this.activeUfOrMun,
      activeElectionId: activeElectionId ?? this.activeElectionId,
      activeRoleCode: activeRoleCode ?? this.activeRoleCode,
    );
  }

  /// Quantidade absoluta de criterios de filtro aplicados.
  int get activeFiltersCount {
    var count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (selectedParty != null) count++;
    if (statusFilter != CandidateStatusFilter.all) count++;
    if (assetsFilter != CandidateAssetsFilter.all) count++;
    return count;
  }

  /// Indica se ha filtros textuais, de legenda, status ou patrimonio aplicados.
  bool get hasActiveFilters => activeFiltersCount > 0;

  /// Indica se a busca retornou vazia apos conclusao com sucesso.
  bool get hasNoResults => status == CandidateListStatus.success && filteredCandidates.isEmpty;

  /// Total absoluto de candidatos retornados pelo cartorio eleitoral.
  int get totalCount => allCandidates.length;

  /// Total de candidatos visiveis apos aplicacao dos filtros.
  int get filteredCount => filteredCandidates.length;

  /// Lista ordenada de siglas de partidos unicos disponiveis na eleicao atual.
  List<String> get availableParties {
    final parties = allCandidates
        .map((candidate) => candidate.partyAcronym.trim().toUpperCase())
        .where((acronym) => acronym.isNotEmpty)
        .toSet()
        .toList();
    parties.sort();
    return parties;
  }

  @override
  List<Object?> get props => [
    status,
    allCandidates,
    filteredCandidates,
    searchQuery,
    selectedParty,
    statusFilter,
    assetsFilter,
    sortOption,
    failure,
    isRefreshing,
    activeYear,
    activeUfOrMun,
    activeElectionId,
    activeRoleCode,
  ];
}
