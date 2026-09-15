import 'package:flutter/material.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Secao analitica de comparacao de patrimonio e bens declarados.
class CandidateComparisonAssetsSection extends StatelessWidget {
  final List<CandidateSummary> candidates;
  final Map<int, CandidateDetail> detailsMap;

  const CandidateComparisonAssetsSection({
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
            _buildSectionTitle(semantic, 'Patrimonio Declarado a Justica Eleitoral'),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Total de Bens Declarados',
              values: candidates.map((c) {
                final amount = c.totalAssetsAmount;
                return amount != null ? CurrencyFormatter.formatBrl(amount) : 'Nao declarado';
              }).toList(),
              isHighlight: true,
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildComparisonRow(
              semantic: semantic,
              label: 'Quantidade de Itens Declarados',
              values: candidates.map((c) {
                final detail = detailsMap[c.id];
                return detail != null ? '${detail.assets.length} item(ns)' : 'Consultando...';
              }).toList(),
            ),
            const Divider(height: AppSpacing.spaceMd),
            _buildLargestAssetRow(semantic),
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
    bool isHighlight = false,
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
                      style: (isHighlight ? AppTypography.titleMedium : AppTypography.bodyMedium)
                          .copyWith(
                            color: isHighlight ? semantic.brandPrimary : semantic.textPrimary,
                            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildLargestAssetRow(AppSemanticColors semantic) {
    final largestAssets = candidates.map((c) {
      final detail = detailsMap[c.id];
      if (detail == null || detail.assets.isEmpty) {
        return 'Nenhum item discriminado';
      }
      final sorted = List.of(detail.assets)..sort((a, b) => b.amount.compareTo(a.amount));
      final top = sorted.first;
      return '${CurrencyFormatter.formatBrl(top.amount)}\n${top.description}';
    }).toList();

    return _buildComparisonRow(
      semantic: semantic,
      label: 'Maior Bem Declarado',
      values: largestAssets,
    );
  }
}
