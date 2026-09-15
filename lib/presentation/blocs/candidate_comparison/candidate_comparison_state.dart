import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';

/// Status do ciclo de vida da carga e exibicao do comparador.
enum CandidateComparisonStatus { initial, loading, success, failure }

/// Estado imutavel do modulo comparador de candidaturas oficiais.
final class CandidateComparisonState extends Equatable {
  static const int maxCandidates = 4;

  final List<CandidateSummary> selectedCandidates;
  final Map<int, CandidateDetail> candidateDetails;
  final CandidateComparisonStatus status;
  final Failure? failure;
  final String? notificationMessage;

  const CandidateComparisonState({
    this.selectedCandidates = const <CandidateSummary>[],
    this.candidateDetails = const <int, CandidateDetail>{},
    this.status = CandidateComparisonStatus.initial,
    this.failure,
    this.notificationMessage,
  });

  /// Indica se ha quantidade suficiente de candidatos para comparacao (minimo 2).
  bool get canCompare => selectedCandidates.length >= 2;

  /// Indica se a capacidade maxima de comparacao foi atingida (4 candidaturas).
  bool get isFull => selectedCandidates.length >= maxCandidates;

  /// Quantidade total de candidaturas atualmente selecionadas.
  int get count => selectedCandidates.length;

  /// Verifica se o candidato com o identificador informado esta selecionado.
  bool isSelected(int candidateId) {
    return selectedCandidates.any((c) => c.id == candidateId);
  }

  /// Retorna os detalhes consolidados de um candidato, caso ja carregados.
  CandidateDetail? detailFor(int candidateId) => candidateDetails[candidateId];

  CandidateComparisonState copyWith({
    List<CandidateSummary>? selectedCandidates,
    Map<int, CandidateDetail>? candidateDetails,
    CandidateComparisonStatus? status,
    Failure? failure,
    String? notificationMessage,
    bool clearNotification = false,
  }) {
    return CandidateComparisonState(
      selectedCandidates: selectedCandidates ?? this.selectedCandidates,
      candidateDetails: candidateDetails ?? this.candidateDetails,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      notificationMessage: clearNotification
          ? null
          : (notificationMessage ?? this.notificationMessage),
    );
  }

  @override
  List<Object?> get props => [
    selectedCandidates,
    candidateDetails,
    status,
    failure,
    notificationMessage,
  ];
}
