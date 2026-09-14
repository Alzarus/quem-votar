import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Painel para acesso as diretrizes e proposta de governo da candidatura (UC04 e RF07).
///
/// Apresenta o status de submissao do plano de diretrizes programaticas perante o
/// Tribunal Superior Eleitoral e disponibiliza acao de visualizacao do arquivo.
class CandidateDetailProposalCard extends StatelessWidget {
  const CandidateDetailProposalCard({super.key, this.proposalDocumentUrl, this.onOpenProposal});

  final String? proposalDocumentUrl;
  final VoidCallback? onOpenProposal;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final hasDocument = proposalDocumentUrl != null && proposalDocumentUrl!.trim().isNotEmpty;

    return Semantics(
      container: true,
      label: hasDocument
          ? 'Diretrizes e proposta de governo disponível'
          : 'Nenhuma proposta de governo informada',
      child: Card(
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
              if (hasDocument) ...[
                _buildAvailableContent(semantic),
              ] else ...[
                _buildUnavailableContent(semantic),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(AppSemanticColors semantic) {
    return Text(
      'Diretrizes e Plano de Governo',
      style: AppTypography.titleMedium.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildAvailableContent(AppSemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documento oficial registrado perante a Justica Eleitoral com as propostas e '
          'diretrizes programaticas de gestao.',
          style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: semantic.brandPrimary,
              side: BorderSide(color: semantic.brandPrimary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceMd,
                vertical: AppSpacing.spaceSm,
              ),
            ),
            icon: const Icon(Icons.description_outlined, size: 20.0),
            label: Text(
              'Acessar Proposta de Governo (PDF)',
              style: AppTypography.labelLarge.copyWith(
                color: semantic.brandPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: onOpenProposal,
          ),
        ),
      ],
    );
  }

  Widget _buildUnavailableContent(AppSemanticColors semantic) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.edgeInsetsSm,
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Text(
        'Nenhum documento de proposta de governo registrado para esta candidatura.',
        style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
      ),
    );
  }
}
