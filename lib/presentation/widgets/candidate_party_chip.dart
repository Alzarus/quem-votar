import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Chip informativo e acessivel para identificacao partidaria e numero de urna.
///
/// Garante contraste cromatico certificado, suporte a ampliacao de texto e area de
/// toque ergonomica quando configurado como elemento interativo.
class CandidatePartyChip extends StatelessWidget {
  const CandidatePartyChip({
    super.key,
    required this.partyAcronym,
    required this.candidateNumber,
    this.coalition,
    this.onTap,
  });

  /// Sigla oficial do partido (ex: "PT", "PL", "MDB").
  final String partyAcronym;

  /// Numero oficial atribuido para votacao na urna eletronica.
  final int candidateNumber;

  /// Nome da coligacao ou federacao partidaria (opcional).
  final String? coalition;

  /// Acao de clique caso o chip seja utilizado como filtro interativo.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final isClickable = onTap != null;
    final displayLabel = '$partyAcronym - $candidateNumber';
    final accessibleLabel = _buildAccessibleLabel();

    Widget chipContent = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: semantic.borderSubtle, width: 1.0),
      ),
      child: ExcludeSemantics(
        child: Text(
          displayLabel,
          style: AppTypography.labelLarge.copyWith(
            color: semantic.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    if (isClickable) {
      chipContent = ConstrainedBox(
        constraints: AppTouchTarget.minConstraints,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Center(child: chipContent),
        ),
      );
    }

    return Semantics(button: isClickable, label: accessibleLabel, child: chipContent);
  }

  String _buildAccessibleLabel() {
    final base = 'Partido $partyAcronym, número de urna $candidateNumber';
    if (coalition != null && coalition!.trim().isNotEmpty) {
      return '$base, coligação ${coalition!.trim()}';
    }
    return base;
  }
}
