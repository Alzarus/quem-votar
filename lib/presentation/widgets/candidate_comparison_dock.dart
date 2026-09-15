import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';

/// Barra flutuante inferior (Dock) para controle de candidaturas selecionadas para comparacao.
///
/// Inspirada no ComparatorDock do portal To de Olho, permite visualizar miniaturas dos
/// candidatos marcados, remover individualmente, limpar selecao e disparar a comparacao.
class CandidateComparisonDock extends StatelessWidget {
  final List<CandidateSummary> selectedCandidates;
  final ValueChanged<int> onRemoveCandidate;
  final VoidCallback onClearSelection;
  final VoidCallback onCompare;

  const CandidateComparisonDock({
    super.key,
    required this.selectedCandidates,
    required this.onRemoveCandidate,
    required this.onClearSelection,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCandidates.isEmpty) {
      return const SizedBox.shrink();
    }

    final semantic = context.semanticColors;
    final canCompare = selectedCandidates.length >= 2;

    return Semantics(
      container: true,
      label: 'Painel de comparação de candidaturas. ${selectedCandidates.length} selecionados.',
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.spaceSm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceSm,
          ),
          decoration: BoxDecoration(
            color: semantic.surfaceCard,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: semantic.borderSubtle, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16.0,
                offset: const Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopControls(context, semantic, canCompare),
              const SizedBox(height: AppSpacing.spaceXs),
              _buildThumbnailsRow(semantic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context, AppSemanticColors semantic, bool canCompare) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: semantic.brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${selectedCandidates.length} selecionado(s)',
                style: AppTypography.labelSmall.copyWith(
                  color: semantic.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            _buildClearButton(semantic),
          ],
        ),
        _buildCompareActionButton(semantic, canCompare),
      ],
    );
  }

  Widget _buildClearButton(AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Limpar todas as candidaturas selecionadas para comparação',
      child: Tooltip(
        message: 'Limpar seleção',
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: IconButton(
            onPressed: onClearSelection,
            icon: Icon(Icons.close, color: semantic.textSecondary, size: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCompareActionButton(AppSemanticColors semantic, bool canCompare) {
    final label = canCompare
        ? 'Comparar ${selectedCandidates.length} candidaturas concorrentes'
        : 'Selecione mais um candidato para comparar';

    return Semantics(
      button: true,
      enabled: canCompare,
      label: label,
      child: SizedBox(
        height: 48.0,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: canCompare ? semantic.brandPrimary : semantic.borderSubtle,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: canCompare ? onCompare : null,
          icon: const Icon(Icons.compare_arrows, size: 18.0),
          label: Text(
            canCompare ? 'Comparar (${selectedCandidates.length})' : 'Selecione +1',
            style: AppTypography.labelLarge.copyWith(
              color: canCompare ? Colors.white : semantic.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailsRow(AppSemanticColors semantic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: selectedCandidates
            .map((c) => _buildCandidateThumbnail(c, semantic))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildCandidateThumbnail(CandidateSummary candidate, AppSemanticColors semantic) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: semantic.brandPrimary, width: 1.5),
            ),
            child: CandidateAvatarWidget(
              candidateName: candidate.ballotName,
              photoUrl: candidate.photoUrl,
              size: 40.0,
            ),
          ),
          Positioned(
            right: -6.0,
            top: -6.0,
            child: Semantics(
              button: true,
              label: 'Remover ${candidate.ballotName} da comparação',
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: semantic.statusIneligible,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => onRemoveCandidate(candidate.id),
                  icon: const Icon(Icons.close, size: 14.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
