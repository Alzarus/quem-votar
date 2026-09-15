import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Barra acessivel de selecao horizontal de cargos oficiais em pills (chips de acao direta).
///
/// Permite ao eleitor alternar entre cargos em disputa (Presidente, Governador, Senador,
/// Deputados) com um unico toque, eliminando menus suspensos profundos e atendendo
/// compulsoriamente a WCAG 2.1 AA com alvos minimos de 48dp.
class CandidateRoleSelectorPills extends StatelessWidget {
  final List<ElectionRole> availableRoles;
  final ElectionRole? selectedRole;
  final ValueChanged<ElectionRole> onRoleSelected;

  const CandidateRoleSelectorPills({
    super.key,
    required this.availableRoles,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    if (availableRoles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Lista horizontal de cargos eletivos disponiveis',
      child: SizedBox(
        height: 48.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < availableRoles.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.spaceXs),
                _buildRolePill(
                  context,
                  availableRoles[i],
                  availableRoles[i] == selectedRole,
                  semantic,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRolePill(
    BuildContext context,
    ElectionRole role,
    bool isSelected,
    AppSemanticColors semantic,
  ) {
    final backgroundColor = isSelected ? semantic.brandPrimary : semantic.surfaceCard;
    final textColor = isSelected ? semantic.surfaceCard : semantic.textPrimary;
    final borderColor = isSelected ? semantic.brandPrimary : semantic.borderSubtle;

    return Semantics(
      button: true,
      selected: isSelected,
      label:
          'Cargo ${role.title}. ${isSelected ? 'Atualmente selecionado.' : 'Toque para selecionar.'}',
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        child: InkWell(
          onTap: isSelected ? null : () => onRoleSelected(role),
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48.0, minWidth: 48.0),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
            ),
            child: Text(
              role.title,
              style: AppTypography.labelLarge.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
