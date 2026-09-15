import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_assets_section.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_civil_data.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_feedback_views.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_header.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_proposal_card.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_running_mates.dart';
import 'package:quem_votar/presentation/widgets/candidate_proposal_modal.dart';

/// Pagina de detalhes da candidatura com qualificacao civil e auditoria patrimonial.
///
/// Implementa observancia a UC02, UC03 e UC04, suporta responsividade adaptativa
/// para telas pequenas e expandidas, e atende plenamente aos padroes WCAG 2.1 AA.
class CandidateDetailPage extends StatelessWidget {
  final CandidateDetailBloc? candidateDetailBloc;
  final VoidCallback? onBack;
  final VoidCallback? onOpenProposal;
  final UrlLauncherService urlLauncherService;

  const CandidateDetailPage({
    super.key,
    this.candidateDetailBloc,
    this.onBack,
    this.onOpenProposal,
    this.urlLauncherService = const DefaultUrlLauncherService(),
  });

  @override
  Widget build(BuildContext context) {
    if (candidateDetailBloc != null) {
      return BlocProvider<CandidateDetailBloc>.value(
        value: candidateDetailBloc!,
        child: _CandidateDetailView(
          onBack: onBack,
          onOpenProposal: onOpenProposal,
          urlLauncherService: urlLauncherService,
        ),
      );
    }
    return _CandidateDetailView(
      onBack: onBack,
      onOpenProposal: onOpenProposal,
      urlLauncherService: urlLauncherService,
    );
  }
}

class _CandidateDetailView extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onOpenProposal;
  final UrlLauncherService urlLauncherService;

  const _CandidateDetailView({this.onBack, this.onOpenProposal, required this.urlLauncherService});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: semantic.surfaceBackground,
        appBar: _buildAppBar(context, semantic),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000.0),
            child: BlocBuilder<CandidateDetailBloc, CandidateDetailState>(
              builder: (context, state) {
                return _buildBodyForState(context, state, semantic);
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppSemanticColors semantic) {
    return AppBar(
      leading: _buildBackButton(context, semantic),
      title: Text(
        'Ficha da Candidatura',
        style: AppTypography.titleMedium.copyWith(
          color: semantic.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: const [],
      elevation: 0.0,
      backgroundColor: semantic.surfaceBackground,
    );
  }

  Widget _buildBackButton(BuildContext context, AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Voltar para listagem de candidatos',
      child: ConstrainedBox(
        constraints: AppTouchTarget.minConstraints,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: semantic.textPrimary),
          onPressed: () => _handleBack(context),
        ),
      ),
    );
  }

  Widget _buildBodyForState(
    BuildContext context,
    CandidateDetailState state,
    AppSemanticColors semantic,
  ) {
    if (state.status == CandidateDetailStatus.loading && state.candidateDetail == null) {
      return const CandidateDetailLoadingView();
    }
    if (state.status == CandidateDetailStatus.failure && state.candidateDetail == null) {
      final message = state.failure?.message ?? 'Falha ao recuperar dados da candidatura.';
      return CandidateDetailErrorView(
        errorMessage: message,
        onRetry: () => _handleRefresh(context),
      );
    }
    if (state.candidateDetail != null) {
      return _buildDetailContent(context, state, state.candidateDetail!, semantic);
    }
    return const CandidateDetailLoadingView();
  }

  Widget _buildDetailContent(
    BuildContext context,
    CandidateDetailState state,
    CandidateDetail detail,
    AppSemanticColors semantic,
  ) {
    return RefreshIndicator(
      color: semantic.brandPrimary,
      onRefresh: () async => _handleRefresh(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceMd,
          vertical: AppSpacing.spaceSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CandidateDetailHeader(candidateDetail: detail),
            const SizedBox(height: AppSpacing.spaceSm),
            CandidateDetailProposalCard(
              proposalDocumentUrl: detail.proposalDocumentUrl,
              onOpenProposal: () =>
                  _handleOpenProposal(context, detail.proposalDocumentUrl, detail.ballotName),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            CandidateDetailCivilData(candidateDetail: detail),
            if (state.hasRunningMates) ...[
              const SizedBox(height: AppSpacing.spaceSm),
              CandidateDetailRunningMates(runningMates: detail.runningMates),
            ],
            const SizedBox(height: AppSpacing.spaceSm),
            CandidateDetailAssetsSection(
              assets: state.sortedAssets,
              totalAmount: state.totalAssetsAmount,
              activeSortOption: state.assetSortOption,
              onSortOptionChanged: (option) => _handleSortOptionChanged(context, option),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
          ],
        ),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void _handleRefresh(BuildContext context) {
    context.read<CandidateDetailBloc>().add(const CandidateDetailRefreshRequested());
  }

  void _handleSortOptionChanged(BuildContext context, CandidateAssetSortOption option) {
    context.read<CandidateDetailBloc>().add(CandidateDetailAssetSortOptionChanged(option));
  }

  Future<void> _handleOpenProposal(
    BuildContext context,
    String? proposalUrl,
    String candidateName,
  ) async {
    if (onOpenProposal != null) {
      onOpenProposal!();
      return;
    }
    if (proposalUrl == null || proposalUrl.trim().isEmpty) {
      return;
    }
    await CandidateProposalModal.show(
      context,
      candidateName: candidateName,
      proposalUrl: proposalUrl,
      urlLauncherService: urlLauncherService,
    );
  }
}
