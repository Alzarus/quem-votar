import 'package:quem_votar/domain/entities/registration_status.dart';

/// Converte e normaliza situacoes juridicas de registro emitidas pela Justica Eleitoral.
///
/// Trata variacoes de maiusculas/minusculas, presenca de acentos ortograficos
/// e codificacoes internas do banco de dados relacional.
abstract final class RegistrationStatusParser {
  /// Converte o texto bruto retornado pela API do TSE na enum [RegistrationStatus].
  static RegistrationStatus parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return RegistrationStatus.unknown;
    }

    final normalized = raw.trim().toUpperCase();

    return switch (normalized) {
      'DEFERIDO' => RegistrationStatus.deferred,
      'DEFERIDO COM RECURSO' => RegistrationStatus.deferredWithAppeal,
      'AGUARDANDO JULGAMENTO' => RegistrationStatus.waitingJudgment,
      'INDEFERIDO' => RegistrationStatus.ineligible,
      'INDEFERIDO COM RECURSO' => RegistrationStatus.ineligibleWithAppeal,
      'CANCELADO' => RegistrationStatus.cancelled,
      'RENÚNCIA' || 'RENUNCIA' => RegistrationStatus.renunciation,
      'FALECIDO' => RegistrationStatus.deceased,
      'CASSADO' => RegistrationStatus.revoked,
      'SUBSTITUÍDO' || 'SUBSTITUIDO' => RegistrationStatus.substituted,
      'NÃO CONHECIMENTO DO PEDIDO' ||
      'NAO CONHECIMENTO DO PEDIDO' => RegistrationStatus.unprocessed,
      _ => RegistrationStatus.unknown,
    };
  }

  /// Converte a enum de dominio para a constante persistida no banco SQLite local.
  static String toStorageString(RegistrationStatus status) {
    return switch (status) {
      RegistrationStatus.deferred => 'DEFERRED',
      RegistrationStatus.deferredWithAppeal => 'DEFERRED_WITH_APPEAL',
      RegistrationStatus.waitingJudgment => 'WAITING_JUDGMENT',
      RegistrationStatus.ineligible => 'INELIGIBLE',
      RegistrationStatus.ineligibleWithAppeal => 'INELIGIBLE_WITH_APPEAL',
      RegistrationStatus.cancelled => 'CANCELLED',
      RegistrationStatus.renunciation => 'RENUNCIATION',
      RegistrationStatus.deceased => 'DECEASED',
      RegistrationStatus.revoked => 'REVOKED',
      RegistrationStatus.substituted => 'SUBSTITUTED',
      RegistrationStatus.unprocessed => 'UNPROCESSED',
      RegistrationStatus.unknown => 'UNKNOWN',
    };
  }

  /// Converte a constante textual persistida no banco SQLite para a enum [RegistrationStatus].
  static RegistrationStatus fromStorageString(String storage) {
    return switch (storage.toUpperCase().trim()) {
      'DEFERRED' => RegistrationStatus.deferred,
      'DEFERRED_WITH_APPEAL' => RegistrationStatus.deferredWithAppeal,
      'WAITING_JUDGMENT' => RegistrationStatus.waitingJudgment,
      'INELIGIBLE' => RegistrationStatus.ineligible,
      'INELIGIBLE_WITH_APPEAL' => RegistrationStatus.ineligibleWithAppeal,
      'CANCELLED' => RegistrationStatus.cancelled,
      'RENUNCIATION' => RegistrationStatus.renunciation,
      'DECEASED' => RegistrationStatus.deceased,
      'REVOKED' => RegistrationStatus.revoked,
      'SUBSTITUTED' => RegistrationStatus.substituted,
      'UNPROCESSED' => RegistrationStatus.unprocessed,
      _ => RegistrationStatus.unknown,
    };
  }
}
