import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_assets_section.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_column_header.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_expenses_section.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_overview_section.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_proposals_section.dart';

/// Pagina dedicada a comparacao analitica direta de 2 a 4 candidaturas oficiais.
///
/// Modela a experiencia comparativa em estrita observancia com o portal To de Olho,
/// disponibilizando matriz analitica de chapa, patrimonio, tetos de gastos e propostas.
class CandidateComparisonPage extends StatelessWidget {
  final CandidateComparisonBloc? comparisonBloc;
  final UrlLauncherService? urlLauncherService;

  const CandidateComparisonPage({super.key, this.comparisonBloc, this.urlLauncherService});

  @override
  Widget build(BuildContext context) {
    if (comparisonBloc != null) {
      return BlocProvider<CandidateComparisonBloc>.value(
        value: comparisonBloc!,
        child: _CandidateComparisonView(urlLauncherService: urlLauncherService),
      );
    }
    return _CandidateComparisonView(urlLauncherService: urlLauncherService);
  }
}

class _CandidateComparisonView extends StatelessWidget {
  final UrlLauncherService? urlLauncherService;

  const _CandidateComparisonView({this.urlLauncherService});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return BlocConsumer<CandidateComparisonBloc, CandidateComparisonState>(
      listener: (context, state) {
        if (state.selectedCandidates.isEmpty && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: semantic.surfaceBackground,
          appBar: _buildAppBar(context, semantic, state),
          body: state.selectedCandidates.isEmpty
              ? _buildEmptyState(context, semantic)
              : _buildComparisonContent(context, semantic, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppSemanticColors semantic,
    CandidateComparisonState state,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparador de Candidaturas',
            style: AppTypography.titleMedium.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${state.count} candidaturas em analise comparativa',
            style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
          ),
        ],
      ),
      backgroundColor: semantic.surfaceCard,
      elevation: 0.0,
      actions: [
        if (state.selectedCandidates.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              context.read<CandidateComparisonBloc>().add(
                const CandidateComparisonSelectionCleared(),
              );
            },
            icon: Icon(Icons.delete_outline, size: 18.0, color: semantic.statusIneligible),
            label: Text(
              'Limpar',
              style: AppTypography.labelLarge.copyWith(color: semantic.statusIneligible),
            ),
          ),
        const SizedBox(width: AppSpacing.spaceSm),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: semantic.borderSubtle, height: 1.0),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppSemanticColors semantic) {
    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.compare_arrows, size: 48.0, color: semantic.textSecondary),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              'Nenhuma candidatura selecionada para comparacao.',
              style: AppTypography.bodyLarge.copyWith(color: semantic.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar a listagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonContent(
    BuildContext context,
    AppSemanticColors semantic,
    CandidateComparisonState state,
  ) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          _buildTabBar(semantic),
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.edgeInsetsMd,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200.0),
                  child: Column(
                    children: [
                      _buildHeadersRow(context, state),
                      const SizedBox(height: AppSpacing.spaceMd),
                      SizedBox(
                        height: 520.0,
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: CandidateComparisonOverviewSection(
                                candidates: state.selectedCandidates,
                                detailsMap: state.candidateDetails,
                              ),
                            ),
                            SingleChildScrollView(
                              child: CandidateComparisonAssetsSection(
                                candidates: state.selectedCandidates,
                                detailsMap: state.candidateDetails,
                              ),
                            ),
                            SingleChildScrollView(
                              child: CandidateComparisonExpensesSection(
                                candidates: state.selectedCandidates,
                                detailsMap: state.candidateDetails,
                              ),
                            ),
                            SingleChildScrollView(
                              child: CandidateComparisonProposalsSection(
                                candidates: state.selectedCandidates,
                                detailsMap: state.candidateDetails,
                                urlLauncherService: urlLauncherService,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppSemanticColors semantic) {
    return Container(
      color: semantic.surfaceCard,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: semantic.brandPrimary,
        unselectedLabelColor: semantic.textSecondary,
        indicatorColor: semantic.brandPrimary,
        tabs: const [
          Tab(text: 'Visao Geral'),
          Tab(text: 'Patrimonio'),
          Tab(text: 'Gastos e Perfil'),
          Tab(text: 'Propostas'),
        ],
      ),
    );
  }

  Widget _buildHeadersRow(BuildContext context, CandidateComparisonState state) {
    final bloc = context.read<CandidateComparisonBloc>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.selectedCandidates
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final candidate = entry.value;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xs),
                child: CandidateComparisonColumnHeader(
                  candidate: candidate,
                  index: index,
                  onRemove: () => bloc.add(CandidateComparisonCandidateRemoved(candidate.id)),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
