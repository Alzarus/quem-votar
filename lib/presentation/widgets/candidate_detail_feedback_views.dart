import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Visao de carregamento esqueleto para a ficha detalhada do candidato.
class CandidateDetailLoadingView extends StatelessWidget {
  const CandidateDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Semantics(
      label: 'Carregando detalhes da candidatura...',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceMd,
          vertical: AppSpacing.spaceSm,
        ),
        child: Column(
          children: [
            _buildSkeletonCard(semantic, height: 160.0),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildSkeletonCard(semantic, height: 220.0),
            const SizedBox(height: AppSpacing.spaceSm),
            _buildSkeletonCard(semantic, height: 180.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(AppSemanticColors semantic, {required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      padding: AppSpacing.edgeInsetsMd,
      decoration: BoxDecoration(
        color: semantic.surfaceCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBar(semantic, width: 140.0, height: 18.0),
          const SizedBox(height: AppSpacing.spaceSm),
          _buildSkeletonBar(semantic, width: double.infinity, height: 14.0),
          const SizedBox(height: AppSpacing.spaceXs),
          _buildSkeletonBar(semantic, width: 220.0, height: 14.0),
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

/// Visao de erro e contingencia para a tela de detalhes.
class CandidateDetailErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CandidateDetailErrorView({super.key, required this.errorMessage, required this.onRetry});

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
              'Nao foi possivel carregar a ficha da candidatura',
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
      label: 'Tentar recarregar ficha detalhada da candidatura',
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
