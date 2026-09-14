import 'package:equatable/equatable.dart';

/// Modalidades de ordenacao para a auditoria patrimonial de bens declarados.
enum CandidateAssetSortOption {
  /// Ordenacao prioritária por maior valor venal (padrao para fiscalizacao civica).
  descendingValue,

  /// Ordenacao por menor valor venal.
  ascendingValue,

  /// Ordem sequencial original de declaracao perante a Justica Eleitoral.
  originalOrder,

  /// Ordenacao alfabetica pelo tipo/categoria oficial do bem.
  category,
}

/// Evento base abstrato para o gerenciamento de estado da ficha do candidato.
abstract class CandidateDetailEvent extends Equatable {
  const CandidateDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Disparado para iniciar o carregamento dos detalhes de uma candidatura oficial.
class CandidateDetailLoadStarted extends CandidateDetailEvent {
  final int year;
  final String ufOrMun;
  final int electionId;
  final int candidateId;
  final bool forceRefresh;

  const CandidateDetailLoadStarted({
    required this.year,
    required this.ufOrMun,
    required this.electionId,
    required this.candidateId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [year, ufOrMun, electionId, candidateId, forceRefresh];
}

/// Disparado para forcar a revalidacao remota dos detalhes (politica SWR).
class CandidateDetailRefreshRequested extends CandidateDetailEvent {
  const CandidateDetailRefreshRequested();
}

/// Disparado para alterar o criterio de ordenacao dos bens patrimoniais declarados.
class CandidateDetailAssetSortOptionChanged extends CandidateDetailEvent {
  final CandidateAssetSortOption sortOption;

  const CandidateDetailAssetSortOptionChanged(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}
