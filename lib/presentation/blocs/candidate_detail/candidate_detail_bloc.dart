import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_state.dart';

/// Gerenciador de estado para consulta detalhada da candidatura e auditoria patrimonial.
///
/// Responsavel por consumir o caso de uso oficial, organizar dados civis, chapa,
/// documentos e ordenar relacao de bens com totalizacao estrita (UC02 e UC03).
class CandidateDetailBloc extends Bloc<CandidateDetailEvent, CandidateDetailState> {
  final GetCandidateDetailUseCase _getCandidateDetailUseCase;

  CandidateDetailBloc({required GetCandidateDetailUseCase getCandidateDetailUseCase})
    : _getCandidateDetailUseCase = getCandidateDetailUseCase,
      super(CandidateDetailState.initial()) {
    on<CandidateDetailLoadStarted>(_onLoadStarted);
    on<CandidateDetailRefreshRequested>(_onRefreshRequested);
    on<CandidateDetailAssetSortOptionChanged>(_onAssetSortOptionChanged);
  }

  Future<void> _onLoadStarted(
    CandidateDetailLoadStarted event,
    Emitter<CandidateDetailState> emit,
  ) async {
    _emitPreFetchLoading(event.forceRefresh, emit);
    final params = GetCandidateDetailParams(
      year: event.year,
      ufOrMun: event.ufOrMun,
      electionId: event.electionId,
      candidateId: event.candidateId,
      forceRefresh: event.forceRefresh,
    );
    await _fetchAndEmitDetail(params, emit);
  }

  void _emitPreFetchLoading(bool forceRefresh, Emitter<CandidateDetailState> emit) {
    if (forceRefresh && state.candidateDetail != null) {
      emit(state.copyWith(isRefreshing: true));
      return;
    }
    emit(state.copyWith(status: CandidateDetailStatus.loading, isRefreshing: false));
  }

  Future<void> _fetchAndEmitDetail(
    GetCandidateDetailParams params,
    Emitter<CandidateDetailState> emit,
  ) async {
    final result = await _getCandidateDetailUseCase.execute(params);
    if (result.isFailure) {
      _emitFailure(result.failureOrNull, emit);
      return;
    }
    final detail = result.successOrNull;
    if (detail == null) {
      _emitEmptyFailure(emit);
      return;
    }
    _emitSuccess(detail, params, emit);
  }

  void _emitEmptyFailure(Emitter<CandidateDetailState> emit) {
    const failure = ServerFailure(
      message: 'Ficha detalhada nao retornada pelo servidor.',
      operationalContext: 'CandidateDetailBloc._fetchAndEmitDetail',
    );
    emit(
      state.copyWith(
        status: CandidateDetailStatus.failure,
        failure: () => failure,
        isRefreshing: false,
      ),
    );
  }

  void _emitFailure(Failure? failure, Emitter<CandidateDetailState> emit) {
    final resolvedFailure =
        failure ??
        const ServerFailure(
          message: 'Falha desconhecida ao recuperar detalhes do candidato.',
          operationalContext: 'CandidateDetailBloc._fetchAndEmitDetail',
        );
    emit(
      state.copyWith(
        status: CandidateDetailStatus.failure,
        failure: () => resolvedFailure,
        isRefreshing: false,
      ),
    );
  }

  void _emitSuccess(
    CandidateDetail detail,
    GetCandidateDetailParams params,
    Emitter<CandidateDetailState> emit,
  ) {
    final sorted = _sortAssets(detail.assets, state.assetSortOption);
    final totalAmount = _calculateTotalAmount(detail);
    emit(
      state.copyWith(
        status: CandidateDetailStatus.success,
        candidateDetail: () => detail,
        sortedAssets: sorted,
        totalAssetsAmount: totalAmount,
        failure: () => null,
        isRefreshing: false,
        activeYear: params.year,
        activeUfOrMun: params.ufOrMun,
        activeElectionId: params.electionId,
        activeCandidateId: params.candidateId,
      ),
    );
  }

  double _calculateTotalAmount(CandidateDetail detail) {
    if (detail.assets.isNotEmpty) {
      return detail.assets.fold<double>(0.0, (sum, asset) => sum + asset.amount);
    }
    return detail.totalAssetsAmount;
  }

  Future<void> _onRefreshRequested(
    CandidateDetailRefreshRequested event,
    Emitter<CandidateDetailState> emit,
  ) async {
    if (state.activeYear == null ||
        state.activeUfOrMun == null ||
        state.activeElectionId == null ||
        state.activeCandidateId == null) {
      return;
    }
    final params = GetCandidateDetailParams(
      year: state.activeYear!,
      ufOrMun: state.activeUfOrMun!,
      electionId: state.activeElectionId!,
      candidateId: state.activeCandidateId!,
      forceRefresh: true,
    );
    _emitPreFetchLoading(true, emit);
    await _fetchAndEmitDetail(params, emit);
  }

  void _onAssetSortOptionChanged(
    CandidateDetailAssetSortOptionChanged event,
    Emitter<CandidateDetailState> emit,
  ) {
    if (state.candidateDetail == null) {
      emit(state.copyWith(assetSortOption: event.sortOption));
      return;
    }
    final sorted = _sortAssets(state.candidateDetail!.assets, event.sortOption);
    emit(state.copyWith(assetSortOption: event.sortOption, sortedAssets: sorted));
  }

  List<CandidateAsset> _sortAssets(
    List<CandidateAsset> assets,
    CandidateAssetSortOption sortOption,
  ) {
    if (assets.length <= 1) return List.unmodifiable(assets);
    final list = List<CandidateAsset>.from(assets);
    switch (sortOption) {
      case CandidateAssetSortOption.descendingValue:
        list.sort((a, b) => b.amount.compareTo(a.amount));
      case CandidateAssetSortOption.ascendingValue:
        list.sort((a, b) => a.amount.compareTo(b.amount));
      case CandidateAssetSortOption.originalOrder:
        list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      case CandidateAssetSortOption.category:
        list.sort((a, b) => a.category.toLowerCase().compareTo(b.category.toLowerCase()));
    }
    return List.unmodifiable(list);
  }
}
