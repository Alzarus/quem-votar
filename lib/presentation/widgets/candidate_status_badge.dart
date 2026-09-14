import 'package:flutter/material.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Badge visual e semantico indicativo da situacao juridica do registro de candidatura.
///
/// Apresenta rotulo conciso com contraste certificado WCAG 2.1 AA e descricao
/// auditavel para leitores de tela em conformidade com o art. 16-A da Lei n. 9.504/1997.
class CandidateStatusBadge extends StatelessWidget {
  const CandidateStatusBadge({super.key, required this.status});

  final RegistrationStatus status;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final color = _resolveStatusColor(semantic);
    final label = _resolveStatusLabel();
    final description = _resolveStatusDescription();

    return Semantics(
      label: 'Situacao do registro: $description',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceXs,
          vertical: AppSpacing.space2xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1.0),
        ),
        child: ExcludeSemantics(
          child: Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Color _resolveStatusColor(AppSemanticColors semantic) {
    return switch (status) {
      RegistrationStatus.deferred => semantic.statusDeferred,
      RegistrationStatus.deferredWithAppeal ||
      RegistrationStatus.waitingJudgment ||
      RegistrationStatus.ineligibleWithAppeal ||
      RegistrationStatus.unprocessed ||
      RegistrationStatus.unknown => semantic.statusPending,
      RegistrationStatus.ineligible ||
      RegistrationStatus.cancelled ||
      RegistrationStatus.renunciation ||
      RegistrationStatus.deceased ||
      RegistrationStatus.revoked ||
      RegistrationStatus.substituted => semantic.statusIneligible,
    };
  }

  String _resolveStatusLabel() {
    return switch (status) {
      RegistrationStatus.deferred => 'Deferido',
      RegistrationStatus.deferredWithAppeal => 'Deferido c/ Recurso',
      RegistrationStatus.waitingJudgment => 'Aguardando Julgamento',
      RegistrationStatus.ineligibleWithAppeal => 'Indeferido c/ Recurso',
      RegistrationStatus.ineligible => 'Indeferido',
      RegistrationStatus.cancelled => 'Cancelado',
      RegistrationStatus.renunciation => 'Renúncia',
      RegistrationStatus.deceased => 'Falecido',
      RegistrationStatus.revoked => 'Cassado',
      RegistrationStatus.substituted => 'Substituído',
      RegistrationStatus.unprocessed => 'Não Conhecido',
      RegistrationStatus.unknown => 'Desconhecido',
    };
  }

  String _resolveStatusDescription() {
    return switch (status) {
      RegistrationStatus.deferred => 'Registro deferido e regular perante a Justiça Eleitoral',
      RegistrationStatus.deferredWithAppeal =>
        'Registro deferido com recurso pendente de julgamento no TSE',
      RegistrationStatus.waitingJudgment => 'Registro aguardando julgamento pela Justiça Eleitoral',
      RegistrationStatus.ineligibleWithAppeal =>
        'Registro indeferido com recurso pendente de julgamento no TSE',
      RegistrationStatus.ineligible => 'Registro indeferido pela Justiça Eleitoral',
      RegistrationStatus.cancelled => 'Registro cancelado pela Justiça Eleitoral',
      RegistrationStatus.renunciation => 'Candidatura com renúncia homologada',
      RegistrationStatus.deceased => 'Candidato falecido',
      RegistrationStatus.revoked => 'Registro de candidatura cassado',
      RegistrationStatus.substituted => 'Candidatura substituída na chapa',
      RegistrationStatus.unprocessed => 'Pedido de registro não conhecido',
      RegistrationStatus.unknown => 'Situação jurídica não identificada',
    };
  }
}
