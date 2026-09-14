import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';

void main() {
  group('RegistrationStatus - Aptidao Juridica e Regras Eleitorais (Art. 16-A)', () {
    test('deve autorizar recebimento de votos para situacoes regulares ou sub judice', () {
      const eligibleStatuses = [
        RegistrationStatus.deferred,
        RegistrationStatus.deferredWithAppeal,
        RegistrationStatus.waitingJudgment,
        RegistrationStatus.ineligibleWithAppeal,
      ];

      for (final status in eligibleStatuses) {
        expect(
          status.isEligibleToVote,
          isTrue,
          reason: 'Status ${status.name} deve ser considerado apto a receber votos.',
        );
      }
    });

    test('deve vetar recebimento de votos para situacoes irregulares, extintas ou nulas', () {
      const ineligibleStatuses = [
        RegistrationStatus.ineligible,
        RegistrationStatus.cancelled,
        RegistrationStatus.renunciation,
        RegistrationStatus.deceased,
        RegistrationStatus.revoked,
        RegistrationStatus.substituted,
        RegistrationStatus.unprocessed,
        RegistrationStatus.unknown,
      ];

      for (final status in ineligibleStatuses) {
        expect(
          status.isEligibleToVote,
          isFalse,
          reason: 'Status ${status.name} nao pode ser considerado apto a receber votos.',
        );
      }
    });

    test('deve conter todos os 12 estados juridicos catalogados', () {
      expect(RegistrationStatus.values.length, equals(12));
    });
  });
}
