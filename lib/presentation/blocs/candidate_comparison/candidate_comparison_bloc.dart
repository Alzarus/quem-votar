import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_state.dart';

/// Gerenciador de estado para o modulo comparador analitico de candidaturas.
///
/// Controla a selecao de 2 a 4 candidatos concorrentes ao mesmo cargo e pleito,
/// gerenciando a carga concorrente das fichas cadastrais completas.
class CandidateComparisonBloc extends Bloc<CandidateComparisonEvent, CandidateComparisonState> {
  final GetCandidateDetailUseCase _getCandidateDetailUseCase;

  CandidateComparisonBloc({required GetCandidateDetailUseCase getCandidateDetailUseCase})
    : _getCandidateDetailUseCase = getCandidateDetailUseCase,
      super(const CandidateComparisonState()) {
    on<CandidateComparisonCandidateToggled>(_onCandidateToggled);
    on<CandidateComparisonCandidateRemoved>(_onCandidateRemoved);
    on<CandidateComparisonSelectionCleared>(_onSelectionCleared);
    on<CandidateComparisonDetailsLoadStarted>(_onDetailsLoadStarted);
  }

  void _onCandidateToggled(
    CandidateComparisonCandidateToggled event,
    Emitter<CandidateComparisonState> emit,
  ) {
    if (state.isSelected(event.candidate.id)) {
      _removeCandidate(event.candidate.id, emit);
      return;
    }
    _addCandidate(event.candidate, emit);
  }

  void _addCandidate(CandidateSummary candidate, Emitter<CandidateComparisonState> emit) {
    if (state.isFull) {
      emit(
        state.copyWith(notificationMessage: 'Limite de 4 candidaturas atingido para comparacao.'),
      );
      return;
    }
    if (_hasDifferentRole(candidate)) {
      emit(
        state.copyWith(
          notificationMessage:
              'Apenas candidaturas concorrentes ao mesmo cargo podem ser comparadas.',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        selectedCandidates: <CandidateSummary>[...state.selectedCandidates, candidate],
        clearNotification: true,
      ),
    );
  }

  bool _hasDifferentRole(CandidateSummary candidate) {
    if (state.selectedCandidates.isEmpty) return false;
    return state.selectedCandidates.first.roleCode != candidate.roleCode;
  }

  void _onCandidateRemoved(
    CandidateComparisonCandidateRemoved event,
    Emitter<CandidateComparisonState> emit,
  ) {
    _removeCandidate(event.candidateId, emit);
  }

  void _removeCandidate(int candidateId, Emitter<CandidateComparisonState> emit) {
    final updatedList = state.selectedCandidates
        .where((c) => c.id != candidateId)
        .toList(growable: false);
    final updatedDetails = Map<int, CandidateDetail>.from(state.candidateDetails)
      ..remove(candidateId);

    emit(
      state.copyWith(
        selectedCandidates: updatedList,
        candidateDetails: updatedDetails,
        clearNotification: true,
      ),
    );
  }

  void _onSelectionCleared(
    CandidateComparisonSelectionCleared event,
    Emitter<CandidateComparisonState> emit,
  ) {
    emit(const CandidateComparisonState());
  }

  Future<void> _onDetailsLoadStarted(
    CandidateComparisonDetailsLoadStarted event,
    Emitter<CandidateComparisonState> emit,
  ) async {
    if (state.selectedCandidates.isEmpty) return;

    emit(state.copyWith(status: CandidateComparisonStatus.loading));
    final detailsMap = Map<int, CandidateDetail>.from(state.candidateDetails);

    final futures = state.selectedCandidates.map(
      (candidate) => _fetchCandidateDetail(candidate.id, event),
    );
    final results = await Future.wait(futures);

    for (final detail in results) {
      if (detail != null) {
        detailsMap[detail.id] = detail;
      }
    }

    emit(state.copyWith(candidateDetails: detailsMap, status: CandidateComparisonStatus.success));
  }

  Future<CandidateDetail?> _fetchCandidateDetail(
    int candidateId,
    CandidateComparisonDetailsLoadStarted event,
  ) async {
    if (state.candidateDetails.containsKey(candidateId)) {
      return state.candidateDetails[candidateId];
    }
    final params = GetCandidateDetailParams(
      year: event.year,
      ufOrMun: event.ufOrMun,
      electionId: event.electionId,
      candidateId: candidateId,
    );
    final result = await _getCandidateDetailUseCase.execute(params);
    return result.successOrNull;
  }
}
