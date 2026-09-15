import 'package:equatable/equatable.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';

/// Hierarquia selada de eventos para o CandidateListBloc.
sealed class CandidateListEvent extends Equatable {
  const CandidateListEvent();

  @override
  List<Object?> get props => [];
}

/// Dispara a carga de candidatos para o pleito, circunscricao e cargo informados.
final class CandidateListLoadStarted extends CandidateListEvent {
  final int year;
  final String ufOrMun;
  final int electionId;
  final int roleCode;
  final bool forceRefresh;

  const CandidateListLoadStarted({
    required this.year,
    required this.ufOrMun,
    required this.electionId,
    required this.roleCode,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [year, ufOrMun, electionId, roleCode, forceRefresh];
}

/// Dispara a recarga forcada dos dados reutilizando os parametros ativos.
final class CandidateListRefreshRequested extends CandidateListEvent {
  const CandidateListRefreshRequested();
}

/// Notifica alteracao no termo de busca textual (submetido a debounce de 300ms).
final class CandidateListSearchQueryChanged extends CandidateListEvent {
  final String query;

  const CandidateListSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Notifica alteracao ou remocao no filtro por legenda partidaria.
final class CandidateListPartyFilterChanged extends CandidateListEvent {
  final String? partyAcronym;

  const CandidateListPartyFilterChanged(this.partyAcronym);

  @override
  List<Object?> get props => [partyAcronym];
}

/// Notifica alteracao no criterio de ordenacao neutra dos candidatos.
final class CandidateListSortOptionChanged extends CandidateListEvent {
  final CandidateSortOption sortOption;

  const CandidateListSortOptionChanged(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

/// Notifica alteracao no filtro de aptidao juridica / situacao de registro.
final class CandidateListStatusFilterChanged extends CandidateListEvent {
  final CandidateStatusFilter statusFilter;

  const CandidateListStatusFilterChanged(this.statusFilter);

  @override
  List<Object?> get props => [statusFilter];
}

/// Notifica alteracao no filtro por faixa de patrimonio declarado.
final class CandidateListAssetsFilterChanged extends CandidateListEvent {
  final CandidateAssetsFilter assetsFilter;

  const CandidateListAssetsFilterChanged(this.assetsFilter);

  @override
  List<Object?> get props => [assetsFilter];
}

/// Notifica a redefinicao e limpeza integral de todos os filtros aplicados.
final class CandidateListFiltersCleared extends CandidateListEvent {
  const CandidateListFiltersCleared();
}
