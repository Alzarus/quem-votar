import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Barra acessivel de visualizacao e remocao rapida de filtros ativos.
///
/// Exibe chips dismissiveis para os parametros atualmente aplicados a listagem,
/// permitindo ao eleitor remover criterios individuais ou limpar todos em 1 acao.
class CandidateActiveFilterBar extends StatelessWidget {
  final String searchQuery;
  final Set<String> selectedParties;
  final CandidateStatusFilter statusFilter;
  final CandidateAssetsFilter assetsFilter;
  final VoidCallback onClearQuery;
  final ValueChanged<String> onRemoveParty;
  final VoidCallback onClearStatus;
  final VoidCallback onClearAssets;
  final VoidCallback onClearAll;

  const CandidateActiveFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedParties,
    required this.statusFilter,
    required this.assetsFilter,
    required this.onClearQuery,
    required this.onRemoveParty,
    required this.onClearStatus,
    required this.onClearAssets,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final chips = _buildActiveChips(semantic);

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2xs),
      child: Wrap(
        spacing: AppSpacing.spaceXs,
        runSpacing: AppSpacing.space2xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [...chips, _buildClearAllButton(semantic)],
      ),
    );
  }

  List<Widget> _buildActiveChips(AppSemanticColors semantic) {
    final list = <Widget>[];

    if (searchQuery.trim().isNotEmpty) {
      list.add(
        _buildChip(
          label: 'Busca: "$searchQuery"',
          semanticLabel: 'Filtro de busca por texto "$searchQuery". Toque para remover.',
          onRemove: onClearQuery,
          semantic: semantic,
        ),
      );
    }

    final sortedParties = selectedParties.toList()..sort();
    for (final party in sortedParties) {
      list.add(
        _buildChip(
          label: 'Partido: $party',
          semanticLabel: 'Filtro por partido $party. Toque para remover.',
          onRemove: () => onRemoveParty(party),
          semantic: semantic,
        ),
      );
    }

    if (statusFilter != CandidateStatusFilter.all) {
      list.add(
        _buildChip(
          label: statusFilter.label,
          semanticLabel: 'Filtro por situacao ${statusFilter.label}. Toque para remover.',
          onRemove: onClearStatus,
          semantic: semantic,
        ),
      );
    }

    if (assetsFilter != CandidateAssetsFilter.all) {
      list.add(
        _buildChip(
          label: assetsFilter.label,
          semanticLabel: 'Filtro por patrimonio ${assetsFilter.label}. Toque para remover.',
          onRemove: onClearAssets,
          semantic: semantic,
        ),
      );
    }

    return list;
  }

  Widget _buildChip({
    required String label,
    required String semanticLabel,
    required VoidCallback onRemove,
    required AppSemanticColors semantic,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSpacing.spaceSm,
          right: AppSpacing.space2xs,
          top: 2.0,
          bottom: 2.0,
        ),
        decoration: BoxDecoration(
          color: semantic.brandPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: semantic.brandPrimary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: semantic.brandPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2.0),
            SizedBox(
              width: 32.0,
              height: 32.0,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 16.0,
                icon: Icon(Icons.close, color: semantic.brandPrimary),
                tooltip: 'Remover filtro',
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearAllButton(AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Limpar todos os filtros ativos',
      child: TextButton(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceSm),
        ),
        onPressed: onClearAll,
        child: Text(
          'Limpar todos',
          style: AppTypography.labelSmall.copyWith(
            color: semantic.statusIneligible,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
