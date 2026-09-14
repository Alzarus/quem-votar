import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/mappers/registration_status_parser.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';

void main() {
  group('RegistrationStatusParser - Parsing e Normalizacao de Status', () {
    test('deve mapear status regulares com caixa mista e acentuacao', () {
      expect(RegistrationStatusParser.parse('Deferido'), equals(RegistrationStatus.deferred));
      expect(
        RegistrationStatusParser.parse('Deferido com recurso'),
        equals(RegistrationStatus.deferredWithAppeal),
      );
      expect(
        RegistrationStatusParser.parse('Aguardando julgamento'),
        equals(RegistrationStatus.waitingJudgment),
      );
      expect(RegistrationStatusParser.parse('Indeferido'), equals(RegistrationStatus.ineligible));
      expect(
        RegistrationStatusParser.parse('Indeferido com recurso'),
        equals(RegistrationStatus.ineligibleWithAppeal),
      );
      expect(RegistrationStatusParser.parse('Cancelado'), equals(RegistrationStatus.cancelled));
      expect(RegistrationStatusParser.parse('Renúncia'), equals(RegistrationStatus.renunciation));
      expect(RegistrationStatusParser.parse('Renuncia'), equals(RegistrationStatus.renunciation));
      expect(RegistrationStatusParser.parse('Falecido'), equals(RegistrationStatus.deceased));
      expect(RegistrationStatusParser.parse('Cassado'), equals(RegistrationStatus.revoked));
      expect(RegistrationStatusParser.parse('Substituído'), equals(RegistrationStatus.substituted));
      expect(RegistrationStatusParser.parse('Substituido'), equals(RegistrationStatus.substituted));
      expect(
        RegistrationStatusParser.parse('Não conhecimento do pedido'),
        equals(RegistrationStatus.unprocessed),
      );
      expect(
        RegistrationStatusParser.parse('Nao conhecimento do pedido'),
        equals(RegistrationStatus.unprocessed),
      );
    });

    test('deve retornar unknown para valores nulos, vazios ou desconhecidos', () {
      expect(RegistrationStatusParser.parse(null), equals(RegistrationStatus.unknown));
      expect(RegistrationStatusParser.parse(''), equals(RegistrationStatus.unknown));
      expect(RegistrationStatusParser.parse('   '), equals(RegistrationStatus.unknown));
      expect(RegistrationStatusParser.parse('STATUS_INVALIDO'), equals(RegistrationStatus.unknown));
    });

    test('deve converter enum para constante de armazenamento no SQLite (toStorageString)', () {
      expect(
        RegistrationStatusParser.toStorageString(RegistrationStatus.deferred),
        equals('DEFERRED'),
      );
      expect(
        RegistrationStatusParser.toStorageString(RegistrationStatus.ineligibleWithAppeal),
        equals('INELIGIBLE_WITH_APPEAL'),
      );
      expect(
        RegistrationStatusParser.toStorageString(RegistrationStatus.renunciation),
        equals('RENUNCIATION'),
      );
      expect(
        RegistrationStatusParser.toStorageString(RegistrationStatus.unknown),
        equals('UNKNOWN'),
      );
    });

    test('deve reconstituir enum a partir da constante de armazenamento (fromStorageString)', () {
      expect(
        RegistrationStatusParser.fromStorageString('DEFERRED'),
        equals(RegistrationStatus.deferred),
      );
      expect(
        RegistrationStatusParser.fromStorageString('DEFERRED_WITH_APPEAL'),
        equals(RegistrationStatus.deferredWithAppeal),
      );
      expect(
        RegistrationStatusParser.fromStorageString('WAITING_JUDGMENT'),
        equals(RegistrationStatus.waitingJudgment),
      );
      expect(
        RegistrationStatusParser.fromStorageString('INELIGIBLE'),
        equals(RegistrationStatus.ineligible),
      );
      expect(
        RegistrationStatusParser.fromStorageString('INELIGIBLE_WITH_APPEAL'),
        equals(RegistrationStatus.ineligibleWithAppeal),
      );
      expect(
        RegistrationStatusParser.fromStorageString('CANCELLED'),
        equals(RegistrationStatus.cancelled),
      );
      expect(
        RegistrationStatusParser.fromStorageString('RENUNCIATION'),
        equals(RegistrationStatus.renunciation),
      );
      expect(
        RegistrationStatusParser.fromStorageString('DECEASED'),
        equals(RegistrationStatus.deceased),
      );
      expect(
        RegistrationStatusParser.fromStorageString('REVOKED'),
        equals(RegistrationStatus.revoked),
      );
      expect(
        RegistrationStatusParser.fromStorageString('SUBSTITUTED'),
        equals(RegistrationStatus.substituted),
      );
      expect(
        RegistrationStatusParser.fromStorageString('UNPROCESSED'),
        equals(RegistrationStatus.unprocessed),
      );
      expect(
        RegistrationStatusParser.fromStorageString('OUTRO_VALOR'),
        equals(RegistrationStatus.unknown),
      );
    });
  });
}
