import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Visao de carregamento com esqueletos acessiveis simulando a estrutura dos cartoes.
class CandidateListLoadingView extends StatelessWidget {
  final int itemCount;

  const CandidateListLoadingView({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Semantics(
      label: 'Carregando candidaturas eleitorais...',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.spaceSm),
        itemBuilder: (_, _) => _buildSkeletonCard(semantic),
      ),
    );
  }

  Widget _buildSkeletonCard(AppSemanticColors semantic) {
    return Container(
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: semantic.surfaceCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: semantic.borderSubtle.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSkeletonBar(semantic, width: 80.0, height: 16.0),
                const SizedBox(height: AppSpacing.spaceXs),
                _buildSkeletonBar(semantic, width: 180.0, height: 18.0),
                const SizedBox(height: AppSpacing.space2xs),
                _buildSkeletonBar(semantic, width: 120.0, height: 14.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonBar(
    AppSemanticColors semantic, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: semantic.borderSubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

/// Visao informativa de resultados vazios com acao de redefinicao de busca.
class CandidateListEmptyView extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;

  const CandidateListEmptyView({super.key, required this.hasActiveFilters, this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56.0, color: semantic.textSecondary),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'Nenhum candidato encontrado',
              style: AppTypography.titleMedium.copyWith(color: semantic.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              _resolveEmptyMessage(),
              style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (hasActiveFilters && onClearFilters != null) ...[
              const SizedBox(height: AppSpacing.spaceLg),
              _buildClearButton(semantic),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveEmptyMessage() {
    if (hasActiveFilters) {
      return 'Nenhum resultado corresponde aos termos ou filtros aplicados.';
    }
    return 'Nenhum registro oficial disponibilizado pela Justiça Eleitoral para este pleito.';
  }

  Widget _buildClearButton(AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Limpar todos os filtros e termos de pesquisa',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0, minWidth: 160.0),
        child: OutlinedButton.icon(
          onPressed: onClearFilters,
          icon: const Icon(Icons.refresh, size: 20.0),
          label: const Text('Limpar Filtros'),
          style: OutlinedButton.styleFrom(
            foregroundColor: semantic.brandPrimary,
            side: BorderSide(color: semantic.brandPrimary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}

/// Visao de contingencia e erro operacional com botao de nova tentativa.
class CandidateListErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CandidateListErrorView({super.key, required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56.0, color: semantic.statusIneligible),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'Não foi possível carregar os dados',
              style: AppTypography.titleMedium.copyWith(color: semantic.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            _buildRetryButton(semantic),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Tentar recarregar dados eleitorais novamente',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0, minWidth: 160.0),
        child: ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.replay, size: 20.0),
          label: const Text('Tentar Novamente'),
          style: ElevatedButton.styleFrom(
            backgroundColor: semantic.brandPrimary,
            foregroundColor: semantic.surfaceBackground,
            elevation: 0.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
