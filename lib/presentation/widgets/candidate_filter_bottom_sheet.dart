import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Modal ergonômico acessivel para configuracao de filtros multicriterio.
///
/// Permite ao eleitor filtrar por situacao juridica (Aptos a voto),
/// faixa de patrimonio declarado oficial e legenda partidaria.
class CandidateFilterBottomSheet extends StatelessWidget {
  final List<String> availableParties;
  final String? selectedParty;
  final CandidateStatusFilter statusFilter;
  final CandidateAssetsFilter assetsFilter;
  final ValueChanged<String?> onPartyChanged;
  final ValueChanged<CandidateStatusFilter> onStatusChanged;
  final ValueChanged<CandidateAssetsFilter> onAssetsChanged;
  final VoidCallback onClearAll;

  const CandidateFilterBottomSheet({
    super.key,
    required this.availableParties,
    required this.selectedParty,
    required this.statusFilter,
    required this.assetsFilter,
    required this.onPartyChanged,
    required this.onStatusChanged,
    required this.onAssetsChanged,
    required this.onClearAll,
  });

  /// Metodo utilitario para exibicao como Modal Bottom Sheet adaptativo.
  static Future<void> show({
    required BuildContext context,
    required List<String> availableParties,
    required String? selectedParty,
    required CandidateStatusFilter statusFilter,
    required CandidateAssetsFilter assetsFilter,
    required ValueChanged<String?> onPartyChanged,
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
        selectedParty: selectedParty,
        statusFilter: statusFilter,
        assetsFilter: assetsFilter,
        onPartyChanged: onPartyChanged,
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
            Flexible(
              child: SingleChildScrollView(
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
              ),
            ),
            Divider(color: semantic.borderSubtle, height: 1.0),
            _buildFooter(context, semantic),
          ],
        ),
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
    return DropdownButtonFormField<String?>(
      initialValue: selectedParty,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Selecionar Legenda Partidária',
        labelStyle: TextStyle(color: semantic.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: semantic.surfaceCard,
      ),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos os Partidos e Federações')),
        ...availableParties.map(
          (party) => DropdownMenuItem<String?>(value: party, child: Text(party)),
        ),
      ],
      onChanged: (newParty) => onPartyChanged(newParty),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required AppSemanticColors semantic,
  }) {
    return ChoiceChip(
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
      side: BorderSide(color: isSelected ? semantic.brandPrimary : semantic.borderSubtle),
      onSelected: (_) => onSelected(),
    );
  }

  Widget _buildFooter(BuildContext context, AppSemanticColors semantic) {
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
          child: const Text(
            'Concluir e Ver Candidaturas',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
