import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/tse_election_mapper.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/domain/entities/election.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  group('TseElectionMapper - Mapeamento de Pleitos Eleitorais', () {
    late List<dynamic> fixtureList;

    setUp(() {
      fixtureList = TseFixtureReader.readJsonList('eleicoes_ordinarias.json');
    });

    test('deve converter DTO de fixture real em entidade Election do Dominio', () {
      final json = fixtureList.first as Map<String, dynamic>;
      final dto = ElectionDto.fromJson(json);
      final entity = TseElectionMapper.fromDto(dto);

      expect(entity, isA<Election>());
      expect(entity.id, equals(20322002026));
      expect(entity.year, equals(2026));
      expect(entity.name, equals('Eleição Geral Federal 2026'));
      expect(entity.type, equals('O'));
      expect(entity.scope, equals('F'));
      expect(entity.electionDate, equals('2026-10-04'));
      expect(entity.description, equals('2026'));
    });

    test('deve converter ElectionData do Drift em entidade Election', () {
      const data = ElectionData(
        id: 2040602022,
        ano: 2022,
        nome: 'Eleicao Geral Federal 2022',
        descricao: 'Eleicoes 2022',
        tipo: 'Ordinaria',
        abrangencia: 'F',
        turno: 1,
        dataEleicao: '2022-10-02',
        situacao: 'Oficial',
      );

      final entity = TseElectionMapper.fromData(data);

      expect(entity.id, equals(2040602022));
      expect(entity.year, equals(2022));
      expect(entity.name, equals('Eleicao Geral Federal 2022'));
      expect(entity.scope, equals('F'));
    });

    test('deve converter ElectionDto em ElectionsTableCompanion para o Drift', () {
      const dto = ElectionDto(
        id: 20322002026,
        year: 2026,
        name: 'Eleicao 2026',
        description: 'Desc 2026',
        type: 'O',
        scope: 'F',
        electionDate: '2026-10-04',
      );

      final companion = TseElectionMapper.toCompanion(dto);

      expect(companion.id.value, equals(20322002026));
      expect(companion.ano.value, equals(2026));
      expect(companion.nome.value, equals('Eleicao 2026'));
      expect(companion.descricao.value, equals('Desc 2026'));
      expect(companion.tipo.value, equals('O'));
      expect(companion.abrangencia.value, equals('F'));
      expect(companion.turno.value, equals(1));
      expect(companion.dataEleicao.value, equals('2026-10-04'));
      expect(companion.situacao.value, equals('Oficial'));
    });
  });
}
