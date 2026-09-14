import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('TseFixtureReader', () {
    test('carrega eleicoes_ordinarias.json como List', () {
      final list = TseFixtureReader.readJsonList('eleicoes_ordinarias.json');
      expect(list, isNotEmpty);
      expect(list.length, equals(3));
    });

    test('carrega cargos_br_2026.json como Map com chave cargos', () {
      final map = TseFixtureReader.readJsonMap('cargos_br_2026.json');
      expect(map.containsKey('cargos'), isTrue);
      final cargos = map['cargos'] as List<dynamic>;
      expect(cargos.length, equals(2));
    });

    test('carrega candidatos_presidente_2026.json como Map com candidatos', () {
      final map = TseFixtureReader.readJsonMap('candidatos_presidente_2026.json');
      expect(map.containsKey('candidatos'), isTrue);
      final candidatos = map['candidatos'] as List<dynamic>;
      expect(candidatos.length, equals(2));
    });

    test('carrega candidato_detalhe_completo.json com bens e vices', () {
      final map = TseFixtureReader.readJsonMap('candidato_detalhe_completo.json');
      expect(map['id'], equals(280001612393));
      expect(map['bens'], isA<List<dynamic>>());
      expect(map['vices'], isA<List<dynamic>>());
      expect(map['arquivos'], isA<List<dynamic>>());
    });

    test('lanca FileNotFoundException para arquivo inexistente', () {
      expect(
        () => TseFixtureReader.readFixture('arquivo_inexistente_12345.json'),
        throwsA(isA<FileNotFoundException>()),
      );
    });

    test('lanca FormatException ao tentar ler List como Map', () {
      expect(
        () => TseFixtureReader.readJsonMap('eleicoes_ordinarias.json'),
        throwsA(isA<FormatException>()),
      );
    });

    test('lanca FormatException ao tentar ler Map como List', () {
      expect(
        () => TseFixtureReader.readJsonList('cargos_br_2026.json'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
