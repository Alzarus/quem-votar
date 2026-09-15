import 'package:flutter/material.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Secao analitica de comparacao de limites de gastos e perfil civil dos candidatos.
class CandidateComparisonExpensesSection extends StatelessWidget {
  final List<CandidateSummary> candidates;
  final Map<int, CandidateDetail> detailsMap;

  const CandidateComparisonExpensesSection({
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
            _buildSectionTitle(semantic, 'Limites de Gastos de Campanha (TSE)'),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Teto 1º Turno',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                if (detail == null) return 'Consultando...';
                return CurrencyFormatter.formatBrl(detail.maxCampaignExpenseFirstTurn);
              }).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Teto 2º Turno',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                if (detail == null) return 'Consultando...';
                final secondTurn = detail.maxCampaignExpenseSecondTurn;
                return secondTurn != null
                    ? CurrencyFormatter.formatBrl(secondTurn)
                    : 'Nao aplicavel';
              }).toList(),
            ),
            const Divider(height: AppSpacing.spaceLg),
            _buildSectionTitle(semantic, 'Perfil e Dados Civis Declarados'),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Ocupacao Declarada',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                return detail?.occupation ?? 'Consultando...';
              }).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Grau de Instrucao',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                return detail?.educationLevel ?? 'Consultando...';
              }).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Naturalidade',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                if (detail == null) return 'Consultando...';
                return '${detail.birthCity} - ${detail.birthState}';
              }).toList(),
            ),
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
                      val,
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
}
