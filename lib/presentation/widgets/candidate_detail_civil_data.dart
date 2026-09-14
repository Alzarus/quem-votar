import 'package:flutter/material.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Painel informativo para exibicao dos dados civis declarados e limites de campanha.
///
/// Apresenta qualificacao pessoal perante a Justica Eleitoral (UC02) e tetos
/// legais autorizados de gastos para primeiro e segundo turnos.
class CandidateDetailCivilData extends StatelessWidget {
  const CandidateDetailCivilData({super.key, required this.candidateDetail});

  final CandidateDetail candidateDetail;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Semantics(
      container: true,
      label: 'Dados civis e limites de despesas de campanha',
      child: Card(
        margin: EdgeInsets.zero,
        color: semantic.surfaceCard,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: semantic.borderSubtle),
        ),
        child: Padding(
          padding: AppSpacing.edgeInsetsMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(semantic),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildCivilDataGrid(semantic),
              const SizedBox(height: AppSpacing.spaceMd),
              Divider(height: 1.0, color: semantic.borderSubtle),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildCampaignLimits(semantic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(AppSemanticColors semantic) {
    return Text(
      'Qualificacao Civil',
      style: AppTypography.titleMedium.copyWith(
        color: semantic.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildCivilDataGrid(AppSemanticColors semantic) {
    final naturalidade = _resolveNaturalidade();
    final dataNascimento = _formatBirthDate(candidateDetail.birthDate);

    return Wrap(
      spacing: AppSpacing.spaceMd,
      runSpacing: AppSpacing.spaceSm,
      children: [
        _buildInfoField('Ocupacao', candidateDetail.occupation, semantic),
        _buildInfoField('Grau de Instrucao', candidateDetail.educationLevel, semantic),
        _buildInfoField('Data de Nascimento', dataNascimento, semantic),
        _buildInfoField('Estado Civil', candidateDetail.maritalStatus, semantic),
        _buildInfoField('Genero', candidateDetail.gender, semantic),
        _buildInfoField('Cor / Raca', candidateDetail.colorRace, semantic),
        _buildInfoField('Nacionalidade', candidateDetail.nationality, semantic),
        _buildInfoField('Naturalidade', naturalidade, semantic),
      ],
    );
  }

  Widget _buildInfoField(String label, String value, AppSemanticColors semantic) {
    final displayValue = value.trim().isNotEmpty ? value : 'Nao informado';

    return SizedBox(
      width: 170.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: semantic.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            displayValue,
            style: AppTypography.bodyMedium.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignLimits(AppSemanticColors semantic) {
    final firstTurn = CurrencyFormatter.formatBrl(candidateDetail.maxCampaignExpenseFirstTurn);
    final secondTurn = candidateDetail.maxCampaignExpenseSecondTurn != null
        ? CurrencyFormatter.formatBrl(candidateDetail.maxCampaignExpenseSecondTurn)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teto Legal de Gastos de Campanha',
          style: AppTypography.labelLarge.copyWith(
            color: semantic.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Wrap(
          spacing: AppSpacing.spaceMd,
          runSpacing: AppSpacing.spaceXs,
          children: [
            _buildExpenseBox('1º Turno', firstTurn, semantic),
            if (secondTurn != null) _buildExpenseBox('2º Turno', secondTurn, semantic),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseBox(String roundTitle, String formattedAmount, AppSemanticColors semantic) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(roundTitle, style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary)),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            formattedAmount,
            style: AppTypography.bodyLarge.copyWith(
              color: semantic.brandPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveNaturalidade() {
    final city = candidateDetail.birthCity.trim();
    final state = candidateDetail.birthState.trim();
    if (city.isNotEmpty && state.isNotEmpty) {
      return '$city ($state)';
    }
    if (city.isNotEmpty) return city;
    if (state.isNotEmpty) return state;
    return 'Nao informada';
  }

  String _formatBirthDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return 'Nao informada';
    final parts = trimmed.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return trimmed;
  }
}
