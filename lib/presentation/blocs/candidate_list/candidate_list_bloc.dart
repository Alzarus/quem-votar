import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/debounce_transformer.dart';
import 'package:quem_votar/core/utils/string_normalizer.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';

/// Gerenciador de estado reativo para a listagem e filtragem de candidatos oficiais.
///
/// Responsavel pelo consumo do caso de uso de consulta eleitoral, filtragem
/// multicriterio com debounce de 300ms (RF02) e ordenacao neutra estrita (RNF03).
class CandidateListBloc extends Bloc<CandidateListEvent, CandidateListState> {
  final GetCandidatesListUseCase _getCandidatesListUseCase;

  CandidateListBloc({required GetCandidatesListUseCase getCandidatesListUseCase})
    : _getCandidatesListUseCase = getCandidatesListUseCase,
      super(CandidateListState.initial()) {
    on<CandidateListLoadStarted>(_onLoadStarted);
    on<CandidateListRefreshRequested>(_onRefreshRequested);
    on<CandidateListSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounceTransformer(const Duration(milliseconds: 300)),
    );
    on<CandidateListPartyFilterChanged>(_onPartyFilterChanged);
    on<CandidateListStatusFilterChanged>(_onStatusFilterChanged);
    on<CandidateListAssetsFilterChanged>(_onAssetsFilterChanged);
    on<CandidateListFiltersCleared>(_onFiltersCleared);
    on<CandidateListSortOptionChanged>(_onSortOptionChanged);
  }

  Future<void> _onLoadStarted(
    CandidateListLoadStarted event,
    Emitter<CandidateListState> emit,
  ) async {
    _emitPreFetchLoading(event.forceRefresh, emit);
    final params = GetCandidatesListParams(
      year: event.year,
      ufOrMun: event.ufOrMun,
      electionId: event.electionId,
      roleCode: event.roleCode,
      forceRefresh: event.forceRefresh,
    );
    await _fetchAndEmitCandidates(params, emit);
  }

  void _emitPreFetchLoading(bool forceRefresh, Emitter<CandidateListState> emit) {
    if (forceRefresh && state.allCandidates.isNotEmpty) {
      emit(state.copyWith(isRefreshing: true));
      return;
    }
    emit(state.copyWith(status: CandidateListStatus.loading, isRefreshing: false));
  }

  Future<void> _fetchAndEmitCandidates(
    GetCandidatesListParams params,
    Emitter<CandidateListState> emit,
  ) async {
    final result = await _getCandidatesListUseCase.execute(params);
    if (result.isFailure) {
      _emitFailure(result.failureOrNull, emit);
      return;
    }
    _emitSuccess(result.successOrNull ?? const [], params, emit);
  }

  void _emitFailure(Failure? failure, Emitter<CandidateListState> emit) {
    final resolvedFailure =
        failure ??
        const ServerFailure(
          message: 'Falha desconhecida ao recuperar candidaturas.',
          operationalContext: 'CandidateListBloc._fetchAndEmitCandidates',
        );
    emit(
      state.copyWith(
        status: CandidateListStatus.failure,
        failure: () => resolvedFailure,
        isRefreshing: false,
      ),
    );
  }

  void _emitSuccess(
    List<CandidateSummary> rawCandidates,
    GetCandidatesListParams params,
    Emitter<CandidateListState> emit,
  ) {
    final filtered = _filterAndSort(
      candidates: rawCandidates,
      query: state.searchQuery,
      party: state.selectedParty,
      statusFilter: state.statusFilter,
      assetsFilter: state.assetsFilter,
      sortOption: state.sortOption,
    );
    emit(
      state.copyWith(
        status: CandidateListStatus.success,
        allCandidates: rawCandidates,
        filteredCandidates: filtered,
        isRefreshing: false,
        failure: () => null,
        activeYear: params.year,
        activeUfOrMun: params.ufOrMun,
        activeElectionId: params.electionId,
        activeRoleCode: params.roleCode,
      ),
    );
  }

  Future<void> _onRefreshRequested(
    CandidateListRefreshRequested event,
    Emitter<CandidateListState> emit,
  ) async {
    if (state.activeYear == null ||
        state.activeUfOrMun == null ||
        state.activeElectionId == null ||
        state.activeRoleCode == null) {
      return;
    }
    final params = GetCandidatesListParams(
      year: state.activeYear!,
      ufOrMun: state.activeUfOrMun!,
      electionId: state.activeElectionId!,
      roleCode: state.activeRoleCode!,
      forceRefresh: true,
    );
    _emitPreFetchLoading(true, emit);
    await _fetchAndEmitCandidates(params, emit);
  }

  void _onSearchQueryChanged(
    CandidateListSearchQueryChanged event,
    Emitter<CandidateListState> emit,
  ) {
    final filtered = _filterAndSort(
      candidates: state.allCandidates,
      query: event.query,
      party: state.selectedParty,
      statusFilter: state.statusFilter,
      assetsFilter: state.assetsFilter,
      sortOption: state.sortOption,
    );
    emit(state.copyWith(searchQuery: event.query, filteredCandidates: filtered));
  }

  void _onPartyFilterChanged(
    CandidateListPartyFilterChanged event,
    Emitter<CandidateListState> emit,
  ) {
    final filtered = _filterAndSort(
      candidates: state.allCandidates,
      query: state.searchQuery,
      party: event.partyAcronym,
      statusFilter: state.statusFilter,
      assetsFilter: state.assetsFilter,
      sortOption: state.sortOption,
    );
    emit(state.copyWith(selectedParty: () => event.partyAcronym, filteredCandidates: filtered));
  }

  void _onStatusFilterChanged(
    CandidateListStatusFilterChanged event,
    Emitter<CandidateListState> emit,
  ) {
    final filtered = _filterAndSort(
      candidates: state.allCandidates,
      query: state.searchQuery,
      party: state.selectedParty,
      statusFilter: event.statusFilter,
      assetsFilter: state.assetsFilter,
      sortOption: state.sortOption,
    );
    emit(state.copyWith(statusFilter: event.statusFilter, filteredCandidates: filtered));
  }

  void _onAssetsFilterChanged(
    CandidateListAssetsFilterChanged event,
    Emitter<CandidateListState> emit,
  ) {
    final filtered = _filterAndSort(
      candidates: state.allCandidates,
      query: state.searchQuery,
      party: state.selectedParty,
      statusFilter: state.statusFilter,
      assetsFilter: event.assetsFilter,
      sortOption: state.sortOption,
    );
    emit(state.copyWith(assetsFilter: event.assetsFilter, filteredCandidates: filtered));
  }

  void _onFiltersCleared(CandidateListFiltersCleared event, Emitter<CandidateListState> emit) {
    final filtered = _filterAndSort(
      candidates: state.allCandidates,
      query: '',
      party: null,
      statusFilter: CandidateStatusFilter.all,
      assetsFilter: CandidateAssetsFilter.all,
      sortOption: state.sortOption,
    );
    emit(
      state.copyWith(
        searchQuery: '',
        selectedParty: () => null,
        statusFilter: CandidateStatusFilter.all,
        assetsFilter: CandidateAssetsFilter.all,
        filteredCandidates: filtered,
      ),
    );
  }

  void _onSortOptionChanged(
    CandidateListSortOptionChanged event,
    Emitter<CandidateListState> emit,
  ) {
    final sorted = _sortCandidates(state.filteredCandidates, event.sortOption);
    emit(state.copyWith(sortOption: event.sortOption, filteredCandidates: sorted));
  }

  List<CandidateSummary> _filterAndSort({
    required List<CandidateSummary> candidates,
    required String query,
    required String? party,
    required CandidateStatusFilter statusFilter,
    required CandidateAssetsFilter assetsFilter,
    required CandidateSortOption sortOption,
  }) {
    final filtered = _filterCandidates(
      candidates: candidates,
      query: query,
      party: party,
      statusFilter: statusFilter,
      assetsFilter: assetsFilter,
    );
    return _sortCandidates(filtered, sortOption);
  }

  List<CandidateSummary> _filterCandidates({
    required List<CandidateSummary> candidates,
    required String query,
    required String? party,
    required CandidateStatusFilter statusFilter,
    required CandidateAssetsFilter assetsFilter,
  }) {
    final normalizedQuery = StringNormalizer.normalize(query);
    final normalizedParty = party?.trim().toUpperCase();

    return candidates
        .where((candidate) {
          if (!_matchesParty(candidate, normalizedParty)) return false;
          if (!_matchesStatus(candidate, statusFilter)) return false;
          if (!_matchesAssets(candidate, assetsFilter)) return false;
          if (normalizedQuery.isEmpty) return true;
          return _matchesQuery(candidate, normalizedQuery);
        })
        .toList(growable: false);
  }

  bool _matchesParty(CandidateSummary candidate, String? normalizedParty) {
    if (normalizedParty == null || normalizedParty.isEmpty) return true;
    return candidate.partyAcronym.trim().toUpperCase() == normalizedParty;
  }

  bool _matchesStatus(CandidateSummary candidate, CandidateStatusFilter statusFilter) {
    return switch (statusFilter) {
      CandidateStatusFilter.all => true,
      CandidateStatusFilter.eligibleOnly => candidate.registrationStatus.isEligibleToVote,
      CandidateStatusFilter.subJudiceOnly =>
        candidate.registrationStatus == RegistrationStatus.deferredWithAppeal ||
            candidate.registrationStatus == RegistrationStatus.ineligibleWithAppeal ||
            candidate.registrationStatus == RegistrationStatus.waitingJudgment,
    };
  }

  bool _matchesAssets(CandidateSummary candidate, CandidateAssetsFilter assetsFilter) {
    final amount = candidate.totalAssetsAmount;
    return switch (assetsFilter) {
      CandidateAssetsFilter.all => true,
      CandidateAssetsFilter.none => amount == null || amount == 0.0,
      CandidateAssetsFilter.upTo200k => amount != null && amount > 0.0 && amount <= 200000.0,
      CandidateAssetsFilter.from200kTo1M =>
        amount != null && amount > 200000.0 && amount <= 1000000.0,
      CandidateAssetsFilter.above1M => amount != null && amount > 1000000.0,
    };
  }

  bool _matchesQuery(CandidateSummary candidate, String normalizedQuery) {
    if (candidate.ballotNumber.toString().contains(normalizedQuery)) return true;
    final normalizedBallot = StringNormalizer.normalize(candidate.ballotName);
    if (normalizedBallot.contains(normalizedQuery)) return true;
    final normalizedFull = StringNormalizer.normalize(candidate.fullName);
    return normalizedFull.contains(normalizedQuery);
  }

  List<CandidateSummary> _sortCandidates(
    List<CandidateSummary> candidates,
    CandidateSortOption sortOption,
  ) {
    final list = List<CandidateSummary>.from(candidates);
    switch (sortOption) {
      case CandidateSortOption.alphabetical:
        list.sort((a, b) => a.ballotName.toLowerCase().compareTo(b.ballotName.toLowerCase()));
      case CandidateSortOption.ballotNumber:
        list.sort((a, b) => a.ballotNumber.compareTo(b.ballotNumber));
      case CandidateSortOption.party:
        list.sort((a, b) => a.partyAcronym.compareTo(b.partyAcronym));
    }
    return list;
  }
}
