import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';
import 'package:quem_votar/presentation/widgets/candidate_party_chip.dart';
import 'package:quem_votar/presentation/widgets/candidate_status_badge.dart';

/// Cabecalho de coluna individual no comparador analitico de candidaturas.
class CandidateComparisonColumnHeader extends StatelessWidget {
  final CandidateSummary candidate;
  final int index;
  final VoidCallback? onRemove;

  const CandidateComparisonColumnHeader({
    super.key,
    required this.candidate,
    required this.index,
    this.onRemove,
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
          children: [
            _buildTopRow(semantic),
            const SizedBox(height: AppSpacing.spaceSm),
            CandidateAvatarWidget(
              candidateName: candidate.ballotName,
              photoUrl: candidate.photoUrl,
              size: 72.0,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              candidate.ballotName,
              style: AppTypography.titleMedium.copyWith(
                color: semantic.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              candidate.fullName,
              style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Wrap(
              spacing: AppSpacing.spaceXs,
              runSpacing: AppSpacing.space2xs,
              alignment: WrapAlignment.center,
              children: [
                CandidatePartyChip(
                  partyAcronym: candidate.partyAcronym,
                  candidateNumber: candidate.ballotNumber,
                  coalition: candidate.coalitionName,
                ),
                CandidateStatusBadge(status: candidate.registrationStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(AppSemanticColors semantic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: semantic.brandPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            'Opcao ${index + 1}',
            style: AppTypography.labelSmall.copyWith(
              color: semantic.brandPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onRemove != null)
          Semantics(
            button: true,
            label: 'Remover ${candidate.ballotName} do comparador',
            child: SizedBox(
              width: 36.0,
              height: 36.0,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onRemove,
                icon: Icon(Icons.close, size: 18.0, color: semantic.textSecondary),
                tooltip: 'Remover',
              ),
            ),
          ),
      ],
    );
  }
}
