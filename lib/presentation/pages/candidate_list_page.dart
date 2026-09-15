import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_state.dart';
import 'package:quem_votar/presentation/pages/candidate_detail_page.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_active_filter_bar.dart';
import 'package:quem_votar/presentation/widgets/candidate_adaptive_grid.dart';
import 'package:quem_votar/presentation/widgets/candidate_filter_bottom_sheet.dart';
import 'package:quem_votar/presentation/widgets/candidate_filter_toolbar.dart';
import 'package:quem_votar/presentation/widgets/candidate_list_feedback_views.dart';
import 'package:quem_votar/presentation/widgets/candidate_list_search_input.dart';
import 'package:quem_votar/presentation/widgets/candidate_role_selector_pills.dart';

/// Pagina principal de consulta e acompanhamento civico de candidaturas oficiais.
///
/// Implementa leiaute adaptativo responsivo em 1, 2 e 3 colunas, selecao rapida de
/// cargos em 1 toque, filtros multicriterio e conformidade WCAG 2.1 AA.
class CandidateListPage extends StatelessWidget {
  final ElectionFilterBloc? electionFilterBloc;
  final CandidateListBloc? candidateListBloc;
  final ValueChanged<CandidateSummary>? onCandidateSelected;

  const CandidateListPage({
    super.key,
    this.electionFilterBloc,
    this.candidateListBloc,
    this.onCandidateSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (electionFilterBloc != null && candidateListBloc != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ElectionFilterBloc>.value(value: electionFilterBloc!),
          BlocProvider<CandidateListBloc>.value(value: candidateListBloc!),
        ],
        child: _CandidateListView(onCandidateSelected: onCandidateSelected),
      );
    }
    return _CandidateListView(onCandidateSelected: onCandidateSelected);
  }
}

class _CandidateListView extends StatelessWidget {
  final ValueChanged<CandidateSummary>? onCandidateSelected;

  const _CandidateListView({this.onCandidateSelected});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Scaffold(
      backgroundColor: semantic.surfaceBackground,
      appBar: _buildAppBar(context, semantic),
      body: BlocListener<ElectionFilterBloc, ElectionFilterState>(
        listenWhen: _shouldReloadCandidates,
        listener: _handleFilterSelectionChanged,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.spaceSm),
                  _buildFilterSection(context),
                  const SizedBox(height: AppSpacing.spaceXs),
                  _buildRolePillsSection(context),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _buildSearchSection(context),
                  _buildActiveFiltersSection(context),
                  const SizedBox(height: AppSpacing.spaceXs),
                  _buildStatusHeader(context, semantic),
                  const SizedBox(height: AppSpacing.space2xs),
                  Expanded(child: _buildCandidatesContent(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppSemanticColors semantic) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quem Votar',
            style: AppTypography.titleMedium.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Transparência e Dados Oficiais do TSE',
            style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
          ),
        ],
      ),
      backgroundColor: semantic.surfaceCard,
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: semantic.borderSubtle, height: 1.0),
      ),
      actions: [_buildRefreshActionButton(context, semantic)],
    );
  }

  Widget _buildRefreshActionButton(BuildContext context, AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Atualizar dados eleitorais do cartório oficial',
      child: SizedBox(
        width: 48.0,
        height: 48.0,
        child: IconButton(
          icon: Icon(Icons.refresh, color: semantic.brandPrimary),
          tooltip: 'Atualizar dados',
          onPressed: () => _triggerRefresh(context),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return BlocBuilder<ElectionFilterBloc, ElectionFilterState>(
      builder: (context, filterState) {
        return BlocBuilder<CandidateListBloc, CandidateListState>(
          builder: (context, listState) {
            return CandidateFilterToolbar(
              availableUfs: filterState.availableUfs,
              selectedUf: filterState.selectedUf,
              onUfChanged: (uf) =>
                  context.read<ElectionFilterBloc>().add(ElectionFilterUfChanged(uf)),
              availableRoles: filterState.availableRoles,
              selectedRole: filterState.selectedRole,
              onRoleChanged: (role) =>
                  context.read<ElectionFilterBloc>().add(ElectionFilterRoleChanged(role)),
              selectedSortOption: listState.sortOption,
              onSortOptionChanged: (sort) =>
                  context.read<CandidateListBloc>().add(CandidateListSortOptionChanged(sort)),
            );
          },
        );
      },
    );
  }

  Widget _buildRolePillsSection(BuildContext context) {
    return BlocBuilder<ElectionFilterBloc, ElectionFilterState>(
      buildWhen: (prev, curr) =>
          prev.availableRoles != curr.availableRoles || prev.selectedRole != curr.selectedRole,
      builder: (context, state) {
        if (state.availableRoles.isEmpty) {
          return const SizedBox.shrink();
        }
        return CandidateRoleSelectorPills(
          availableRoles: state.availableRoles,
          selectedRole: state.selectedRole,
          onRoleSelected: (role) =>
              context.read<ElectionFilterBloc>().add(ElectionFilterRoleChanged(role)),
        );
      },
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return BlocBuilder<CandidateListBloc, CandidateListState>(
      buildWhen: (prev, curr) =>
          prev.searchQuery != curr.searchQuery ||
          prev.activeFiltersCount != curr.activeFiltersCount,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: CandidateListSearchInput(
                initialQuery: state.searchQuery,
                onQueryChanged: (query) =>
                    context.read<CandidateListBloc>().add(CandidateListSearchQueryChanged(query)),
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            _buildFilterModalButton(context, state),
          ],
        );
      },
    );
  }

  Widget _buildFilterModalButton(BuildContext context, CandidateListState state) {
    final semantic = context.semanticColors;
    final hasFilters = state.hasActiveFilters;
    final count = state.activeFiltersCount;

    return Semantics(
      button: true,
      label:
          'Abrir painel de filtros multicritério. ${hasFilters ? '$count filtros ativos.' : 'Nenhum filtro ativo.'}',
      child: Badge(
        isLabelVisible: hasFilters,
        label: Text('$count'),
        backgroundColor: semantic.brandPrimary,
        textColor: semantic.surfaceCard,
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: hasFilters
                  ? semantic.brandPrimary.withValues(alpha: 0.1)
                  : semantic.surfaceCard,
              side: BorderSide(
                color: hasFilters ? semantic.brandPrimary : semantic.borderSubtle,
                width: hasFilters ? 1.5 : 1.0,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            onPressed: () => _openFilterBottomSheet(context),
            child: Icon(
              Icons.tune,
              color: hasFilters ? semantic.brandPrimary : semantic.textPrimary,
              size: 22.0,
            ),
          ),
        ),
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
    final listBloc = context.read<CandidateListBloc>();
    final state = listBloc.state;

    CandidateFilterBottomSheet.show(
      context: context,
      availableParties: state.availableParties,
      selectedParty: state.selectedParty,
      statusFilter: state.statusFilter,
      assetsFilter: state.assetsFilter,
      onPartyChanged: (party) => listBloc.add(CandidateListPartyFilterChanged(party)),
      onStatusChanged: (status) => listBloc.add(CandidateListStatusFilterChanged(status)),
      onAssetsChanged: (assets) => listBloc.add(CandidateListAssetsFilterChanged(assets)),
      onClearAll: () => listBloc.add(const CandidateListFiltersCleared()),
    );
  }

  Widget _buildActiveFiltersSection(BuildContext context) {
    return BlocBuilder<CandidateListBloc, CandidateListState>(
      buildWhen: (prev, curr) =>
          prev.searchQuery != curr.searchQuery ||
          prev.selectedParty != curr.selectedParty ||
          prev.statusFilter != curr.statusFilter ||
          prev.assetsFilter != curr.assetsFilter,
      builder: (context, state) {
        if (!state.hasActiveFilters) {
          return const SizedBox.shrink();
        }
        final bloc = context.read<CandidateListBloc>();
        return CandidateActiveFilterBar(
          searchQuery: state.searchQuery,
          selectedParty: state.selectedParty,
          statusFilter: state.statusFilter,
          assetsFilter: state.assetsFilter,
          onClearQuery: () => bloc.add(const CandidateListSearchQueryChanged('')),
          onClearParty: () => bloc.add(const CandidateListPartyFilterChanged(null)),
          onClearStatus: () =>
              bloc.add(const CandidateListStatusFilterChanged(CandidateStatusFilter.all)),
          onClearAssets: () =>
              bloc.add(const CandidateListAssetsFilterChanged(CandidateAssetsFilter.all)),
          onClearAll: () => bloc.add(const CandidateListFiltersCleared()),
        );
      },
    );
  }

  Widget _buildStatusHeader(BuildContext context, AppSemanticColors semantic) {
    return BlocBuilder<CandidateListBloc, CandidateListState>(
      builder: (context, state) {
        if (state.status != CandidateListStatus.success) {
          return const SizedBox.shrink();
        }
        final text = 'Exibindo ${state.filteredCount} de ${state.totalCount} candidaturas';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xs),
          child: Text(
            text,
            style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
          ),
        );
      },
    );
  }

  Widget _buildCandidatesContent(BuildContext context) {
    return BlocBuilder<ElectionFilterBloc, ElectionFilterState>(
      builder: (context, filterState) {
        if (filterState.status == ElectionFilterStatus.loading) {
          return const CandidateListLoadingView();
        }
        if (filterState.status == ElectionFilterStatus.failure) {
          final message =
              filterState.failure?.message ?? 'Falha ao carregar pleitos oficiais do TSE.';
          return CandidateListErrorView(
            errorMessage: message,
            onRetry: () => _triggerRefresh(context),
          );
        }

        return BlocBuilder<CandidateListBloc, CandidateListState>(
          builder: (context, state) {
            if (state.status == CandidateListStatus.loading && !state.isRefreshing) {
              return const CandidateListLoadingView();
            }
            if (state.status == CandidateListStatus.failure) {
              final message = state.failure?.message ?? 'Falha ao recuperar registros do TSE.';
              return CandidateListErrorView(
                errorMessage: message,
                onRetry: () => _triggerRefresh(context),
              );
            }
            if (state.hasNoResults) {
              return CandidateListEmptyView(
                hasActiveFilters: state.hasActiveFilters,
                onClearFilters: () => _clearFilters(context),
              );
            }
            if (state.status == CandidateListStatus.success) {
              return CandidateAdaptiveGrid(
                key: const PageStorageKey('candidate_adaptive_grid_key'),
                candidates: state.filteredCandidates,
                onCandidateSelected: (candidate) => _handleCandidateSelected(context, candidate),
                onRefresh: () async => _triggerRefresh(context),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  bool _shouldReloadCandidates(ElectionFilterState prev, ElectionFilterState curr) {
    return curr.hasValidSelection &&
        (prev.selectedElection != curr.selectedElection ||
            prev.selectedUf != curr.selectedUf ||
            prev.selectedRole != curr.selectedRole);
  }

  void _handleFilterSelectionChanged(BuildContext context, ElectionFilterState state) {
    final election = state.selectedElection!;
    final uf = state.selectedUf!;
    final role = state.selectedRole!;

    context.read<CandidateListBloc>().add(
      CandidateListLoadStarted(
        year: election.year,
        ufOrMun: uf.acronym,
        electionId: election.id,
        roleCode: role.code,
      ),
    );
  }

  void _triggerRefresh(BuildContext context) {
    final filterBloc = context.read<ElectionFilterBloc>();
    final filterState = filterBloc.state;
    if (filterState.status == ElectionFilterStatus.failure) {
      filterBloc.add(const ElectionFilterStarted());
      return;
    }
    if (filterState.hasValidSelection) {
      final election = filterState.selectedElection!;
      final uf = filterState.selectedUf!;
      final role = filterState.selectedRole!;

      context.read<CandidateListBloc>().add(
        CandidateListLoadStarted(
          year: election.year,
          ufOrMun: uf.acronym,
          electionId: election.id,
          roleCode: role.code,
          forceRefresh: true,
        ),
      );
      return;
    }
    context.read<CandidateListBloc>().add(const CandidateListRefreshRequested());
  }

  void _clearFilters(BuildContext context) {
    context.read<CandidateListBloc>().add(const CandidateListSearchQueryChanged(''));
    context.read<CandidateListBloc>().add(const CandidateListPartyFilterChanged(null));
    context.read<CandidateListBloc>().add(const CandidateListFiltersCleared());
  }

  void _handleCandidateSelected(BuildContext context, CandidateSummary candidate) {
    if (onCandidateSelected != null) {
      onCandidateSelected!(candidate);
      return;
    }
    _navigateToDetail(context, candidate);
  }

  void _navigateToDetail(BuildContext context, CandidateSummary candidate) {
    final filterState = context.read<ElectionFilterBloc>().state;
    final electionId = filterState.selectedElection?.id ?? 20322002026;
    final year = filterState.selectedElection?.year ?? 2026;
    final uf = filterState.selectedUf?.acronym ?? 'BR';

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (navContext) {
          final detailUseCase = _resolveDetailUseCase(context);
          if (detailUseCase != null) {
            final detailBloc = CandidateDetailBloc(getCandidateDetailUseCase: detailUseCase)
              ..add(
                CandidateDetailLoadStarted(
                  year: year,
                  ufOrMun: uf,
                  electionId: electionId,
                  candidateId: candidate.id,
                ),
              );
            return CandidateDetailPage(candidateDetailBloc: detailBloc);
          }
          return const CandidateDetailPage();
        },
      ),
    );
  }

  GetCandidateDetailUseCase? _resolveDetailUseCase(BuildContext context) {
    try {
      return context.read<GetCandidateDetailUseCase>();
    } catch (_) {
      return null;
    }
  }
}
