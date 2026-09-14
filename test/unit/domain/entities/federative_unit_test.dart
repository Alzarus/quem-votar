import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';

void main() {
  group('FederativeUnit - Dominio e Classificacao Territorial', () {
    test('deve conter exatamente 28 circunscricoes catalogadas', () {
      expect(FederativeUnit.values.length, equals(28));
      expect(FederativeUnit.allUnits.length, equals(28));
      expect(FederativeUnit.allUnits.first, equals(FederativeUnit.br));
    });

    test('deve identificar corretamente a circunscricao nacional', () {
      expect(FederativeUnit.br.isNational, isTrue);
      expect(FederativeUnit.br.isFederalDistrict, isFalse);
      expect(FederativeUnit.br.isState, isFalse);
      expect(FederativeUnit.br.acronym, equals('BR'));
      expect(FederativeUnit.br.name, equals('Brasil'));
    });

    test('deve identificar corretamente o Distrito Federal', () {
      expect(FederativeUnit.df.isNational, isFalse);
      expect(FederativeUnit.df.isFederalDistrict, isTrue);
      expect(FederativeUnit.df.isState, isFalse);
      expect(FederativeUnit.df.acronym, equals('DF'));
      expect(FederativeUnit.df.name, equals('Distrito Federal'));
    });

    test('deve identificar corretamente os estados federados', () {
      expect(FederativeUnit.sp.isNational, isFalse);
      expect(FederativeUnit.sp.isFederalDistrict, isFalse);
      expect(FederativeUnit.sp.isState, isTrue);
      expect(FederativeUnit.rj.isState, isTrue);
      expect(FederativeUnit.mg.isState, isTrue);
    });

    test('deve resolver instancia a partir da sigla em maiusculo e minusculo', () {
      expect(FederativeUnit.fromAcronymOrNull('BR'), equals(FederativeUnit.br));
      expect(FederativeUnit.fromAcronymOrNull('sp'), equals(FederativeUnit.sp));
      expect(FederativeUnit.fromAcronymOrNull(' Df '), equals(FederativeUnit.df));
    });

    test('deve retornar null para siglas inexistentes ou vazias', () {
      expect(FederativeUnit.fromAcronymOrNull(null), isNull);
      expect(FederativeUnit.fromAcronymOrNull(''), isNull);
      expect(FederativeUnit.fromAcronymOrNull('   '), isNull);
      expect(FederativeUnit.fromAcronymOrNull('XX'), isNull);
      expect(FederativeUnit.fromAcronymOrNull('USA'), isNull);
    });
  });
}
