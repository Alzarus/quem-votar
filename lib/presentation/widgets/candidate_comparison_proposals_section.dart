import 'package:flutter/material.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_proposal_modal.dart';

/// Secao de acesso e comparacao das propostas de governo registradas no TSE.
class CandidateComparisonProposalsSection extends StatelessWidget {
  final List<CandidateSummary> candidates;
  final Map<int, CandidateDetail> detailsMap;
  final UrlLauncherService? urlLauncherService;

  const CandidateComparisonProposalsSection({
    super.key,
    required this.candidates,
    required this.detailsMap,
    this.urlLauncherService,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Card(
      margin: EdgeInsets.zero,
      color: semantic.surfaceCard,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: semantic.borderSubtle),
      ),
      child: Padding(
        padding: AppSpacing.edgeInsetsMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(semantic),
            const SizedBox(height: AppSpacing.spaceSm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: candidates
                  .map(
                    (candidate) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
                        child: _buildProposalButton(context, candidate, semantic),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(AppSemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Propostas de Governo Registradas no TSE',
          style: AppTypography.titleMedium.copyWith(
            color: semantic.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          'Acesse e coteje o plano de governo oficial de cada candidatura.',
          style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProposalButton(
    BuildContext context,
    CandidateSummary candidate,
    AppSemanticColors semantic,
  ) {
    final detail = detailsMap[candidate.id];
    final url = detail?.proposalDocumentUrl;
    final hasUrl = url != null && url.trim().isNotEmpty;

    return Semantics(
      button: hasUrl,
      label: hasUrl
          ? 'Abrir proposta de governo de ${candidate.ballotName}'
          : 'Proposta de governo nao cadastrada para ${candidate.ballotName}',
      child: SizedBox(
        height: 48.0,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceSm),
            side: BorderSide(color: hasUrl ? semantic.brandPrimary : semantic.borderSubtle),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: hasUrl ? () => _openProposal(context, candidate, url) : null,
          icon: Icon(
            Icons.description_outlined,
            size: 18.0,
            color: hasUrl ? semantic.brandPrimary : semantic.textSecondary,
          ),
          label: Text(
            hasUrl ? 'Ver Proposta' : 'Indisponivel',
            style: AppTypography.labelLarge.copyWith(
              color: hasUrl ? semantic.brandPrimary : semantic.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _openProposal(BuildContext context, CandidateSummary candidate, String url) {
    CandidateProposalModal.show(
      context,
      candidateName: candidate.ballotName,
      proposalUrl: url,
      urlLauncherService: urlLauncherService ?? const DefaultUrlLauncherService(),
    );
  }
}
