import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/utils/string_normalizer.dart';

void main() {
  group('StringNormalizer', () {
    test('deve retornar string vazia para entrada vazia ou com espacos', () {
      expect(StringNormalizer.normalize(''), equals(''));
      expect(StringNormalizer.normalize('   '), equals(''));
    });

    test('deve remover diacriticos e converter para caixa baixa', () {
      expect(StringNormalizer.normalize('João da Silva'), equals('joao da silva'));
      expect(StringNormalizer.normalize('TARCÍSIO'), equals('tarcisio'));
      expect(StringNormalizer.normalize('São Paulo'), equals('sao paulo'));
      expect(StringNormalizer.normalize('Á É Í Ó Ú Ç Ã Õ'), equals('a e i o u c a o'));
    });

    test('deve preservar numeros e caracteres sem alteracao', () {
      expect(StringNormalizer.normalize('13'), equals('13'));
      expect(StringNormalizer.normalize('Candidato 22'), equals('candidato 22'));
    });

    test('deve aparar espacos iniciais e finais', () {
      expect(StringNormalizer.normalize('  Luiz Inacio  '), equals('luiz inacio'));
    });
  });
}
