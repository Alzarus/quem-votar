import 'package:equatable/equatable.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';

/// Hierarquia abstrata de eventos para gerenciamento do comparador de candidaturas.
sealed class CandidateComparisonEvent extends Equatable {
  const CandidateComparisonEvent();

  @override
  List<Object?> get props => [];
}

/// Alterna a presenca de uma candidatura na selecao comparativa (adiciona ou remove).
final class CandidateComparisonCandidateToggled extends CandidateComparisonEvent {
  final CandidateSummary candidate;

  const CandidateComparisonCandidateToggled(this.candidate);

  @override
  List<Object?> get props => [candidate];
}

/// Remove individualmente uma candidatura da lista de comparacao pelo seu identificador.
final class CandidateComparisonCandidateRemoved extends CandidateComparisonEvent {
  final int candidateId;

  const CandidateComparisonCandidateRemoved(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}

/// Esvazia integralmente a lista de candidaturas selecionadas para comparacao.
final class CandidateComparisonSelectionCleared extends CandidateComparisonEvent {
  const CandidateComparisonSelectionCleared();
}

/// Dispara o carregamento simultaneo dos dados cadastrais aprofundados dos candidatos selecionados.
final class CandidateComparisonDetailsLoadStarted extends CandidateComparisonEvent {
  final int year;
  final String ufOrMun;
  final int electionId;

  const CandidateComparisonDetailsLoadStarted({
    required this.year,
    required this.ufOrMun,
    required this.electionId,
  });

  @override
  List<Object?> get props => [year, ufOrMun, electionId];
}
