import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Secao analitica de comparacao de chapa e situacao cadastral.
class CandidateComparisonOverviewSection extends StatelessWidget {
  final List<CandidateSummary> candidates;
  final Map<int, CandidateDetail> detailsMap;

  const CandidateComparisonOverviewSection({
    super.key,
    required this.candidates,
    required this.detailsMap,
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
            _buildSectionTitle(semantic, 'Composicao da Chapa e Registro Oficial'),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Partido / Federacao',
              values: candidates.map((c) => c.partyAcronym).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Coligacao',
              values: candidates.map((c) => c.coalitionName).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Situacao Juridica',
              values: candidates.map((c) => c.rawStatusDescription).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildRunningMatesRow(semantic),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(AppSemanticColors semantic, String title) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildComparisonRow({
    required AppSemanticColors semantic,
    required String label,
    required List<String> values,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: semantic.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values
              .map(
                (val) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
                    child: Text(
                      val.isNotEmpty ? val : 'Nao informado',
                      style: AppTypography.bodyMedium.copyWith(
                        color: semantic.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildRunningMatesRow(AppSemanticColors semantic) {
    final matesList = candidates.map((c) {
      final detail = detailsMap[c.id];
      if (detail == null || detail.runningMates.isEmpty) {
        return 'Nenhum suplente/vice registrado';
      }
      return detail.runningMates.map((m) => '${m.ballotName} (${m.roleDescription})').join('\n');
    }).toList();

    return _buildComparisonRow(
      semantic: semantic,
      label: 'Vice / Suplentes na Chapa',
      values: matesList,
    );
  }
}
