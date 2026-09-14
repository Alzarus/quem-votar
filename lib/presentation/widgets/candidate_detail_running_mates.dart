import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';

/// Painel para exibicao dos membros da chapa majoritaria ou suplentes (RF06).
///
/// Apresenta vice-presidente, vice-governador, vice-prefeito ou suplentes de
/// senador vinculados a candidatura titular perante a Justica Eleitoral.
class CandidateDetailRunningMates extends StatelessWidget {
  const CandidateDetailRunningMates({super.key, required this.runningMates});

  final List<RunningMate> runningMates;

  @override
  Widget build(BuildContext context) {
    if (runningMates.isEmpty) return const SizedBox.shrink();

    final semantic = context.semanticColors;

    return Semantics(
      container: true,
      label: 'Composicao de chapa majoritaria e suplencias',
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
              ...runningMates.map((mate) => _buildRunningMateItem(mate, semantic)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(AppSemanticColors semantic) {
    return Text(
      'Chapa Majoritaria e Suplencias',
      style: AppTypography.titleMedium.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildRunningMateItem(RunningMate mate, AppSemanticColors semantic) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
      padding: AppSpacing.edgeInsetsSm,
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CandidateAvatarWidget(
            candidateName: mate.ballotName,
            photoUrl: mate.photoUrl,
            size: 48.0,
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(child: _buildMateDetails(mate, semantic)),
          _buildEligibilityChip(mate.isEligible, semantic),
        ],
      ),
    );
  }

  Widget _buildMateDetails(RunningMate mate, AppSemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mate.ballotName,
          style: AppTypography.labelLarge.copyWith(
            color: semantic.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          '${mate.roleDescription} • ${mate.partyAcronym}',
          style: AppTypography.labelSmall.copyWith(
            color: semantic.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (mate.fullName.isNotEmpty && mate.fullName != mate.ballotName) ...[
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            mate.fullName,
            style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildEligibilityChip(bool isEligible, AppSemanticColors semantic) {
    final color = isEligible ? semantic.statusDeferred : semantic.statusIneligible;
    final label = isEligible ? 'Apto' : 'Inapto';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceXs,
        vertical: AppSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
