import 'package:flutter/material.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';
import 'package:quem_votar/presentation/widgets/candidate_party_chip.dart';
import 'package:quem_votar/presentation/widgets/candidate_status_badge.dart';

/// Cartao sintetico responsivo e acessivel para apresentacao de candidaturas oficiais.
///
/// Implementa conformidade estrita com WCAG 2.1 AA, alvo de toque minimo de 48dp,
/// rotulacao semantica para tecnologias assistivas e expansao fluida sob textScaler.
class CandidateCard extends StatelessWidget {
  const CandidateCard({super.key, required this.candidate, this.onTap});

  final CandidateSummary candidate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final accessibleLabel = _buildAccessibleLabel();

    return Semantics(
      button: onTap != null,
      label: accessibleLabel,
      child: Card(
        margin: EdgeInsets.zero,
        color: semantic.surfaceCard,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: semantic.borderSubtle),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: AppSpacing.edgeInsetsMd,
            child: ExcludeSemantics(child: _buildCardContent(semantic)),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(AppSemanticColors semantic) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CandidateAvatarWidget(
          candidateName: candidate.ballotName,
          photoUrl: candidate.photoUrl,
          size: 60.0,
        ),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBadgesRow(),
              const SizedBox(height: AppSpacing.space2xs),
              _buildCandidateName(semantic),
              _buildFullName(semantic),
              const SizedBox(height: AppSpacing.spaceXs),
              _buildDeclaredAssets(semantic),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesRow() {
    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.space2xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CandidatePartyChip(
          partyAcronym: candidate.partyAcronym,
          candidateNumber: candidate.ballotNumber,
          coalition: candidate.coalitionName,
        ),
        CandidateStatusBadge(status: candidate.registrationStatus),
      ],
    );
  }

  Widget _buildCandidateName(AppSemanticColors semantic) {
    return Text(
      candidate.ballotName,
      style: AppTypography.titleMedium.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFullName(AppSemanticColors semantic) {
    return Text(
      candidate.fullName,
      style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDeclaredAssets(AppSemanticColors semantic) {
    final formatted = CurrencyFormatter.formatBrl(candidate.totalAssetsAmount);
    return Text(
      'Bens declarados: $formatted',
      style: AppTypography.bodyMedium.copyWith(
        color: semantic.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _buildAccessibleLabel() {
    final formatted = CurrencyFormatter.formatBrl(candidate.totalAssetsAmount);
    return 'Candidatura de ${candidate.ballotName}, partido ${candidate.partyAcronym}, '
        'número ${candidate.ballotNumber}. Situação do registro: '
        '${candidate.registrationStatus.name}. Bens declarados: $formatted. '
        'Tocar para ver detalhes cadastrais.';
  }
}
