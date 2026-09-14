import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/widgets/candidate_card.dart';

/// Grelha adaptativa de candidaturas com reorganizacao dinamica de colunas.
///
/// Implementa adaptabilidade fluida sem alturas fixas, garantindo suporte
/// a expansao tipografica (textScaler) de ate 200% sem estouro de leiaute:
/// - Compacto (< 600 dp): 1 coluna
/// - Medio (600 a 840 dp): 2 colunas
/// - Expandido (> 840 dp): 3 colunas
class CandidateAdaptiveGrid extends StatelessWidget {
  final List<CandidateSummary> candidates;
  final ValueChanged<CandidateSummary>? onCandidateSelected;
  final RefreshCallback? onRefresh;

  const CandidateAdaptiveGrid({
    super.key,
    required this.candidates,
    this.onCandidateSelected,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = _resolveColumnCount(constraints.maxWidth);
        return _buildScrollableContent(columnCount);
      },
    );
  }

  int _resolveColumnCount(double maxWidth) {
    if (maxWidth < 600.0) return 1;
    if (maxWidth <= 840.0) return 2;
    return 3;
  }

  Widget _buildScrollableContent(int columnCount) {
    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: _buildListView(columnCount));
    }
    return _buildListView(columnCount);
  }

  Widget _buildListView(int columnCount) {
    if (columnCount == 1) {
      return _buildSingleColumnList();
    }
    return _buildMultiColumnList(columnCount);
  }

  Widget _buildSingleColumnList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.edgeInsetsMd,
      itemCount: candidates.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.spaceSm),
      itemBuilder: (context, index) {
        final candidate = candidates[index];
        return CandidateCard(
          candidate: candidate,
          onTap: () => onCandidateSelected?.call(candidate),
        );
      },
    );
  }

  Widget _buildMultiColumnList(int columnCount) {
    final rowCount = (candidates.length / columnCount).ceil();

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.edgeInsetsMd,
      itemCount: rowCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.spaceSm),
      itemBuilder: (context, rowIndex) {
        return _buildGridRow(rowIndex, columnCount);
      },
    );
  }

  Widget _buildGridRow(int rowIndex, int columnCount) {
    final startIndex = rowIndex * columnCount;
    final rowWidgets = <Widget>[];

    for (var col = 0; col < columnCount; col++) {
      if (col > 0) {
        rowWidgets.add(const SizedBox(width: AppSpacing.spaceSm));
      }
      final itemIndex = startIndex + col;
      rowWidgets.add(_buildGridCell(itemIndex));
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowWidgets);
  }

  Widget _buildGridCell(int itemIndex) {
    if (itemIndex >= candidates.length) {
      return const Expanded(child: SizedBox.shrink());
    }
    final candidate = candidates[itemIndex];
    return Expanded(
      child: CandidateCard(candidate: candidate, onTap: () => onCandidateSelected?.call(candidate)),
    );
  }
}
