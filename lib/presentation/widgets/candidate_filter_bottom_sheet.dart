import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Modal ergonômico acessivel para configuracao de filtros multicriterio.
///
/// Permite ao eleitor filtrar por situacao juridica (Aptos a voto),
/// faixa de patrimonio declarado oficial e selecao multipartidaria simultanea.
class CandidateFilterBottomSheet extends StatelessWidget {
  final List<String> availableParties;
  final Set<String> selectedParties;
  final CandidateStatusFilter statusFilter;
  final CandidateAssetsFilter assetsFilter;
  final ValueChanged<String> onPartyToggled;
  final ValueChanged<CandidateStatusFilter> onStatusChanged;
  final ValueChanged<CandidateAssetsFilter> onAssetsChanged;
  final VoidCallback onClearAll;

  const CandidateFilterBottomSheet({
    super.key,
    required this.availableParties,
    required this.selectedParties,
    required this.statusFilter,
    required this.assetsFilter,
    required this.onPartyToggled,
    required this.onStatusChanged,
    required this.onAssetsChanged,
    required this.onClearAll,
  });

  /// Metodo utilitario para exibicao como Modal Bottom Sheet adaptativo.
  static Future<void> show({
    required BuildContext context,
    required List<String> availableParties,
    required Set<String> selectedParties,
    required CandidateStatusFilter statusFilter,
    required CandidateAssetsFilter assetsFilter,
    required ValueChanged<String> onPartyToggled,
    required ValueChanged<CandidateStatusFilter> onStatusChanged,
    required ValueChanged<CandidateAssetsFilter> onAssetsChanged,
    required VoidCallback onClearAll,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CandidateFilterBottomSheet(
        availableParties: availableParties,
        selectedParties: selectedParties,
        statusFilter: statusFilter,
        assetsFilter: assetsFilter,
        onPartyToggled: onPartyToggled,
        onStatusChanged: onStatusChanged,
        onAssetsChanged: onAssetsChanged,
        onClearAll: onClearAll,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        maxWidth: 600.0,
      ),
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDragHandle(semantic),
            _buildHeader(context, semantic),
            Divider(color: semantic.borderSubtle, height: 1.0),
            Flexible(child: _buildScrollableBody(semantic)),
            Divider(color: semantic.borderSubtle, height: 1.0),
            _buildFooter(context, semantic),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableBody(AppSemanticColors semantic) {
    return SingleChildScrollView(
      padding: AppSpacing.edgeInsetsMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Situação Jurídica do Registro', semantic),
          const SizedBox(height: AppSpacing.spaceXs),
          _buildStatusOptions(semantic),
          const SizedBox(height: AppSpacing.spaceMd),
          _buildSectionTitle('Patrimônio Declarado no TSE', semantic),
          const SizedBox(height: AppSpacing.spaceXs),
          _buildAssetsOptions(semantic),
          const SizedBox(height: AppSpacing.spaceMd),
          _buildSectionTitle('Partido / Federação Partidária', semantic),
          const SizedBox(height: AppSpacing.spaceXs),
          _buildPartyOptions(semantic),
        ],
      ),
    );
  }

  Widget _buildDragHandle(AppSemanticColors semantic) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
        width: 36.0,
        height: 4.0,
        decoration: BoxDecoration(
          color: semantic.borderSubtle,
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppSemanticColors semantic) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filtros de Candidaturas',
            style: AppTypography.titleMedium.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: onClearAll,
                child: Text('Limpar', style: TextStyle(color: semantic.brandPrimary)),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Fechar filtros',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppSemanticColors semantic) {
    return Text(
      title,
      style: AppTypography.labelLarge.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildStatusOptions(AppSemanticColors semantic) {
    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.spaceXs,
      children: CandidateStatusFilter.values.map((filter) {
        final isSelected = filter == statusFilter;
        return _buildChoiceChip(
          label: filter.label,
          isSelected: isSelected,
          onSelected: () => onStatusChanged(filter),
          semantic: semantic,
        );
      }).toList(),
    );
  }

  Widget _buildAssetsOptions(AppSemanticColors semantic) {
    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.spaceXs,
      children: CandidateAssetsFilter.values.map((filter) {
        final isSelected = filter == assetsFilter;
        return _buildChoiceChip(
          label: filter.label,
          isSelected: isSelected,
          onSelected: () => onAssetsChanged(filter),
          semantic: semantic,
        );
      }).toList(),
    );
  }

  Widget _buildPartyOptions(AppSemanticColors semantic) {
    if (availableParties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
        child: Text(
          'Nenhuma legenda partidária disponível para esta seleção.',
          style: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
        ),
      );
    }

    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.spaceXs,
      children: availableParties.map((party) {
        final isSelected = selectedParties.contains(party);
        return FilterChip(
          avatar: isSelected ? Icon(Icons.check, size: 16.0, color: semantic.surfaceCard) : null,
          label: Text(
            party,
            style: TextStyle(
              color: isSelected ? semantic.surfaceCard : semantic.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: semantic.brandPrimary,
          backgroundColor: semantic.surfaceCard,
          side: BorderSide(
            color: isSelected ? semantic.brandPrimary : semantic.borderSubtle,
            width: isSelected ? 1.6 : 1.0,
          ),
          onSelected: (_) => onPartyToggled(party),
        );
      }).toList(),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required AppSemanticColors semantic,
  }) {
    return ChoiceChip(
      avatar: isSelected ? Icon(Icons.check, size: 16.0, color: semantic.surfaceCard) : null,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? semantic.surfaceCard : semantic.textPrimary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedColor: semantic.brandPrimary,
      backgroundColor: semantic.surfaceCard,
      side: BorderSide(
        color: isSelected ? semantic.brandPrimary : semantic.borderSubtle,
        width: isSelected ? 1.6 : 1.0,
      ),
      onSelected: (_) => onSelected(),
    );
  }

  Widget _buildFooter(BuildContext context, AppSemanticColors semantic) {
    final totalCount = _calcTotalCriteria();
    final buttonLabel = totalCount > 0
        ? 'Concluir e Ver Candidaturas ($totalCount)'
        : 'Concluir e Ver Candidaturas';

    return Padding(
      padding: AppSpacing.edgeInsetsMd,
      child: SizedBox(
        height: 48.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: semantic.brandPrimary,
            foregroundColor: semantic.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  int _calcTotalCriteria() {
    var count = 0;
    count += selectedParties.length;
    if (statusFilter != CandidateStatusFilter.all) count++;
    if (assetsFilter != CandidateAssetsFilter.all) count++;
    return count;
  }
}
