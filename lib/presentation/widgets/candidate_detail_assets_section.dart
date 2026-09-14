import 'package:flutter/material.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Painel de auditoria do patrimonio declarado a Justica Eleitoral (UC03 e RF04).
///
/// Consolida o somatorio geral de bens em BRL, permite reordenacao parametrica
/// e lista de forma pormenorizada cada item declarado com total conformidade WCAG.
class CandidateDetailAssetsSection extends StatelessWidget {
  const CandidateDetailAssetsSection({
    super.key,
    required this.assets,
    required this.totalAmount,
    required this.activeSortOption,
    this.onSortOptionChanged,
  });

  final List<CandidateAsset> assets;
  final double totalAmount;
  final CandidateAssetSortOption activeSortOption;
  final ValueChanged<CandidateAssetSortOption>? onSortOptionChanged;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Semantics(
      container: true,
      label:
          'Auditoria do patrimonio declarado. Total: ${CurrencyFormatter.formatBrl(totalAmount)}',
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
              _buildHeader(semantic),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildTotalConsolidationCard(semantic),
              const SizedBox(height: AppSpacing.spaceMd),
              if (assets.isNotEmpty) ...[
                _buildSortToolbar(semantic),
                const SizedBox(height: AppSpacing.spaceSm),
                ...assets.map((asset) => _buildAssetItem(asset, semantic)),
              ] else
                _buildEmptyAssetsMessage(semantic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppSemanticColors semantic) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.spaceSm,
      runSpacing: AppSpacing.space2xs,
      children: [
        Text(
          'Patrimonio Declarado',
          style: AppTypography.titleMedium.copyWith(
            color: semantic.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceXs,
            vertical: AppSpacing.space2xs,
          ),
          decoration: BoxDecoration(
            color: semantic.surfaceBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: semantic.borderSubtle),
          ),
          child: Text(
            '${assets.length} ${assets.length == 1 ? "item" : "itens"}',
            style: AppTypography.labelSmall.copyWith(
              color: semantic.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalConsolidationCard(AppSemanticColors semantic) {
    final formattedTotal = CurrencyFormatter.formatBrl(totalAmount);

    return Container(
      width: double.infinity,
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: semantic.brandPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.brandPrimary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Declarado a Justica Eleitoral',
            style: AppTypography.labelSmall.copyWith(
              color: semantic.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            formattedTotal,
            style: AppTypography.displayLarge.copyWith(
              color: semantic.brandPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 24.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortToolbar(AppSemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ordenar por:',
          style: AppTypography.labelSmall.copyWith(
            color: semantic.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: CandidateAssetSortOption.values.map((option) {
              return _buildSortOptionChip(option, semantic);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptionChip(CandidateAssetSortOption option, AppSemanticColors semantic) {
    final isSelected = option == activeSortOption;
    final label = _resolveSortLabel(option);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.spaceXs),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: 'Ordenar bens por $label',
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: ActionChip(
            label: Text(label),
            labelStyle: AppTypography.labelSmall.copyWith(
              color: isSelected ? semantic.brandPrimary : semantic.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            backgroundColor: isSelected
                ? semantic.brandPrimary.withValues(alpha: 0.12)
                : semantic.surfaceBackground,
            side: BorderSide(
              color: isSelected ? semantic.brandPrimary : semantic.borderSubtle,
              width: isSelected ? 1.5 : 1.0,
            ),
            onPressed: () => onSortOptionChanged?.call(option),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetItem(CandidateAsset asset, AppSemanticColors semantic) {
    final formattedValue = CurrencyFormatter.formatBrl(asset.amount);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
      padding: AppSpacing.edgeInsetsSm,
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.spaceSm,
            runSpacing: AppSpacing.space2xs,
            children: [
              Text(
                asset.category,
                style: AppTypography.labelLarge.copyWith(
                  color: semantic.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                formattedValue,
                style: AppTypography.bodyLarge.copyWith(
                  color: semantic.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (asset.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              asset.description,
              style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyAssetsMessage(AppSemanticColors semantic) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Text(
        'Nenhum bem patrimonial declarado perante a Justica Eleitoral.',
        style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _resolveSortLabel(CandidateAssetSortOption option) {
    return switch (option) {
      CandidateAssetSortOption.descendingValue => 'Maior Valor',
      CandidateAssetSortOption.ascendingValue => 'Menor Valor',
      CandidateAssetSortOption.originalOrder => 'Ordem Registro',
      CandidateAssetSortOption.category => 'Categoria',
    };
  }
}
