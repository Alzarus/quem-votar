import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/election_role.dart';

void main() {
  group('ElectionRole - Mapeamento de Cargos Oficiais do TSE (Codigos 1 a 13)', () {
    test('deve conter exatamente os 13 cargos oficiais da Justica Eleitoral', () {
      expect(ElectionRole.values.length, equals(13));
    });

    test('deve mapear codigos validos para a enum correspondente via fromCodeOrNull', () {
      expect(ElectionRole.fromCodeOrNull(1), equals(ElectionRole.president));
      expect(ElectionRole.fromCodeOrNull(2), equals(ElectionRole.vicePresident));
      expect(ElectionRole.fromCodeOrNull(3), equals(ElectionRole.governor));
      expect(ElectionRole.fromCodeOrNull(4), equals(ElectionRole.viceGovernor));
      expect(ElectionRole.fromCodeOrNull(5), equals(ElectionRole.senator));
      expect(ElectionRole.fromCodeOrNull(6), equals(ElectionRole.federalDeputy));
      expect(ElectionRole.fromCodeOrNull(7), equals(ElectionRole.stateDeputy));
      expect(ElectionRole.fromCodeOrNull(8), equals(ElectionRole.districtDeputy));
      expect(ElectionRole.fromCodeOrNull(9), equals(ElectionRole.firstAlternateSenator));
      expect(ElectionRole.fromCodeOrNull(10), equals(ElectionRole.secondAlternateSenator));
      expect(ElectionRole.fromCodeOrNull(11), equals(ElectionRole.mayor));
      expect(ElectionRole.fromCodeOrNull(12), equals(ElectionRole.viceMayor));
      expect(ElectionRole.fromCodeOrNull(13), equals(ElectionRole.councilor));
    });

    test('deve retornar null para codigos numericos inexistentes ou fora de faixa', () {
      expect(ElectionRole.fromCodeOrNull(0), isNull);
      expect(ElectionRole.fromCodeOrNull(14), isNull);
      expect(ElectionRole.fromCodeOrNull(-1), isNull);
    });

    test('deve classificar corretamente cargos executivos e legislativos', () {
      expect(ElectionRole.president.isExecutive, isTrue);
      expect(ElectionRole.governor.isExecutive, isTrue);
      expect(ElectionRole.mayor.isExecutive, isTrue);
      expect(ElectionRole.senator.isExecutive, isFalse);
      expect(ElectionRole.federalDeputy.isExecutive, isFalse);
      expect(ElectionRole.councilor.isExecutive, isFalse);
    });

    test('deve distinguir sistemas eleitorais majoritarios de proporcionais', () {
      expect(ElectionRole.president.isMajoritarian, isTrue);
      expect(ElectionRole.senator.isMajoritarian, isTrue);
      expect(ElectionRole.federalDeputy.isProportional, isTrue);
      expect(ElectionRole.stateDeputy.isProportional, isTrue);
      expect(ElectionRole.districtDeputy.isProportional, isTrue);
      expect(ElectionRole.councilor.isProportional, isTrue);
    });
  });
}
