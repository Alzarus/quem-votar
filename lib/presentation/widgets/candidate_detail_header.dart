import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';
import 'package:quem_votar/presentation/widgets/candidate_party_chip.dart';
import 'package:quem_votar/presentation/widgets/candidate_status_badge.dart';

/// Cabecalho institucional para apresentacao dos dados centrais de candidatura.
///
/// Exibe fotografia oficial com resolucao de contingencia, nome de urna em destaque,
/// nome civil completo, cargo pleiteado, partido e situacao juridica auditavel.
class CandidateDetailHeader extends StatelessWidget {
  const CandidateDetailHeader({super.key, required this.candidateDetail});

  final CandidateDetail candidateDetail;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Semantics(
      container: true,
      label: _buildAccessibleHeaderLabel(),
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
              _buildTopIdentityRow(semantic),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildBadgesAndRoleRow(semantic),
              if (_hasStatusNote) ...[
                const SizedBox(height: AppSpacing.spaceSm),
                _buildStatusDescriptionBox(semantic),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIdentityRow(AppSemanticColors semantic) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CandidateAvatarWidget(
          candidateName: candidateDetail.ballotName,
          photoUrl: candidateDetail.photoUrl,
          size: 72.0,
        ),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                candidateDetail.ballotName,
                style: AppTypography.headlineMedium.copyWith(
                  color: semantic.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.space2xs),
              Text(
                candidateDetail.fullName,
                style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesAndRoleRow(AppSemanticColors semantic) {
    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.space2xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CandidatePartyChip(
          partyAcronym: candidateDetail.partyAcronym,
          candidateNumber: candidateDetail.ballotNumber,
          coalition: candidateDetail.coalitionName,
        ),
        CandidateStatusBadge(status: candidateDetail.registrationStatus),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceXs,
            vertical: AppSpacing.space2xs,
          ),
          decoration: BoxDecoration(
            color: semantic.surfaceBackground,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: semantic.borderSubtle),
          ),
          child: Text(
            candidateDetail.roleDescription,
            style: AppTypography.labelSmall.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  bool get _hasStatusNote {
    final note = candidateDetail.rawStatusDescription.trim();
    return note.isNotEmpty;
  }

  Widget _buildStatusDescriptionBox(AppSemanticColors semantic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informacao da Justica Eleitoral',
            style: AppTypography.labelSmall.copyWith(
              color: semantic.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            candidateDetail.rawStatusDescription,
            style: AppTypography.bodyMedium.copyWith(color: semantic.textPrimary),
          ),
        ],
      ),
    );
  }

  String _buildAccessibleHeaderLabel() {
    return 'Candidatura de ${candidateDetail.ballotName}, nome civil ${candidateDetail.fullName}. '
        'Cargo: ${candidateDetail.roleDescription}. Partido: ${candidateDetail.partyAcronym}, '
        'número ${candidateDetail.ballotNumber}. Situação: ${candidateDetail.registrationStatus.name}.';
  }
}
