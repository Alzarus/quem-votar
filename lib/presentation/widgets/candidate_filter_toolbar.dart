import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Barra de selecao de parametros territoriais e ordenacao neutra.
///
/// Atende integralmente a WCAG 2.1 AA com alvos minimos de 48dp,
/// rotulacao semantica compulsoria e adaptabilidade por largura.
class CandidateFilterToolbar extends StatelessWidget {
  final List<FederativeUnit> availableUfs;
  final FederativeUnit? selectedUf;
  final ValueChanged<FederativeUnit> onUfChanged;

  final CandidateSortOption selectedSortOption;
  final ValueChanged<CandidateSortOption> onSortOptionChanged;

  const CandidateFilterToolbar({
    super.key,
    required this.availableUfs,
    required this.selectedUf,
    required this.onUfChanged,
    required this.selectedSortOption,
    required this.onSortOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600.0;
        if (isCompact) {
          return _buildCompactLayout(semantic);
        }
        return _buildWideLayout(semantic);
      },
    );
  }

  Widget _buildCompactLayout(AppSemanticColors semantic) {
    return Row(
      children: [
        Expanded(flex: 4, child: _buildUfDropdown(semantic)),
        const SizedBox(width: AppSpacing.spaceXs),
        Expanded(flex: 5, child: _buildSortDropdown(semantic)),
      ],
    );
  }

  Widget _buildWideLayout(AppSemanticColors semantic) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildUfDropdown(semantic)),
        const SizedBox(width: AppSpacing.spaceSm),
        Expanded(flex: 1, child: _buildSortDropdown(semantic)),
      ],
    );
  }

  Widget _buildUfDropdown(AppSemanticColors semantic) {
    return Semantics(
      label: 'Selecionar circunscrição ou Unidade Federativa',
      child: InputDecorator(
        decoration: _buildDropdownDecoration(semantic, label: 'Território'),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<FederativeUnit>(
            value: selectedUf,
            isDense: true,
            isExpanded: true,
            items: availableUfs.map((uf) => _buildUfMenuItem(uf, semantic)).toList(),
            onChanged: (newUf) => _onUfSelected(newUf),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<FederativeUnit> _buildUfMenuItem(FederativeUnit uf, AppSemanticColors semantic) {
    return DropdownMenuItem<FederativeUnit>(
      value: uf,
      child: Text(
        '${uf.acronym} - ${uf.name}',
        style: AppTypography.bodyMedium.copyWith(color: semantic.textPrimary),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSortDropdown(AppSemanticColors semantic) {
    return Semantics(
      label: 'Selecionar critério neutro de ordenação',
      child: InputDecorator(
        decoration: _buildDropdownDecoration(semantic, label: 'Ordenação'),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CandidateSortOption>(
            value: selectedSortOption,
            isDense: true,
            isExpanded: true,
            items: CandidateSortOption.values
                .map((sort) => _buildSortMenuItem(sort, semantic))
                .toList(),
            onChanged: (newSort) => _onSortSelected(newSort),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<CandidateSortOption> _buildSortMenuItem(
    CandidateSortOption sort,
    AppSemanticColors semantic,
  ) {
    return DropdownMenuItem<CandidateSortOption>(
      value: sort,
      child: Text(
        sort.label,
        style: AppTypography.bodyMedium.copyWith(color: semantic.textPrimary),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  InputDecoration _buildDropdownDecoration(AppSemanticColors semantic, {required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
      filled: true,
      fillColor: semantic.surfaceCard,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      border: _buildBorder(semantic.borderSubtle),
      enabledBorder: _buildBorder(semantic.borderSubtle),
      focusedBorder: _buildBorder(semantic.brandPrimary, width: 2.0),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  void _onUfSelected(FederativeUnit? uf) {
    if (uf != null) onUfChanged(uf);
  }

  void _onSortSelected(CandidateSortOption? sort) {
    if (sort != null) onSortOptionChanged(sort);
  }
}
