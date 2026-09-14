import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/models/candidate_asset_dto.dart';
import 'package:quem_votar/data/models/candidate_file_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/models/candidate_list_item_dto.dart';
import 'package:quem_votar/data/models/cargos_envelope_dto.dart';
import 'package:quem_votar/data/models/election_cargo_dto.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/data/models/running_mate_dto.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  group('DTOs - Parsing Defensivo de JSON e Serializacao', () {
    test('ElectionDto deve serializar e desserializar com simetria', () {
      const json = {
        'id': 20322002026,
        'ano': 2026,
        'nomeEleicao': 'Eleicao 2026',
        'descricaoEleicao': 'Desc',
        'tipoEleicao': 'O',
        'tipoAbrangencia': 'F',
        'dataEleicao': '2026-10-04',
      };
      final dto = ElectionDto.fromJson(json);

      expect(dto.id, equals(20322002026));
      expect(dto.toJson(), equals(json));
    });

    test('CandidateListEnvelopeDto deve desserializar fixture candidatos_presidente_2026.json', () {
      final map = TseFixtureReader.readJsonMap('candidatos_presidente_2026.json');
      final envelope = CandidateListEnvelopeDto.fromJson(map);

      expect(envelope.stateCode, equals('BR'));
      expect(envelope.stateName, equals('BRASIL'));
      expect(envelope.roleCode, equals(1));
      expect(envelope.roleName, equals('Presidente'));
      expect(envelope.candidates.length, equals(2));
      expect(envelope.candidates.first.ballotName, equals('CIRO GOMES'));
    });

    test('CargosEnvelopeDto deve desserializar fixture cargos_br_2026.json', () {
      final map = TseFixtureReader.readJsonMap('cargos_br_2026.json');
      final envelope = CargosEnvelopeDto.fromJson(map);

      expect(envelope.stateCode, equals('BR'));
      expect(envelope.stateName, equals('BRASIL'));
      expect(envelope.cargos.length, equals(2));
      expect(envelope.cargos.first.code, equals(1));
      expect(envelope.cargos.first.name, equals('Presidente'));
      expect(envelope.cargos[1].code, equals(2));
      expect(envelope.cargos[1].isTitular, isFalse);
    });

    test('ElectionCargoDto deve serializar e desserializar corretamente', () {
      const json = {
        'codigo': 1,
        'sigla': 'P',
        'nome': 'Presidente',
        'codSuperior': 0,
        'titular': true,
        'contagem': 10,
      };
      final dto = ElectionCargoDto.fromJson(json);

      expect(dto.code, equals(1));
      expect(dto.toJson(), equals(json));
    });

    test('CandidateAssetDto deve converter valor numerico ou String formatada', () {
      final numDto = CandidateAssetDto.fromJson(const {
        'ordem': 1,
        'descricaoDeTipoDeBem': 'Imovel',
        'descricao': 'Casa',
        'valor': 350000.50,
        'dataUltimaAtualizacao': '2026-08-01',
      });
      expect(numDto.amount, equals(350000.50));

      final strDto = CandidateAssetDto.fromJson(const {
        'ordem': 2,
        'descricaoDeTipoDeBem': 'Carro',
        'descricao': 'Veiculo',
        'valor': '120000,75',
        'dataUltimaAtualizacao': '2026-08-01',
      });
      expect(strDto.amount, equals(120000.75));

      final nullDto = CandidateAssetDto.fromJson(const {
        'ordem': 3,
        'descricaoDeTipoDeBem': 'Outro',
        'descricao': 'Item',
        'valor': null,
        'dataUltimaAtualizacao': '2026-08-01',
      });
      expect(nullDto.amount, equals(0.0));
    });

    test('RunningMateDto deve converter numero de urna String ou numerico', () {
      final strDto = RunningMateDto.fromJson(const {
        'sq_CANDIDATO': 101,
        'sq_CANDIDATO_SUPERIOR': 100,
        'nr_CANDIDATO': '13',
        'nm_URNA': 'VICE',
        'nm_CANDIDATO': 'NOME VICE',
        'ds_CARGO': 'Vice',
        'sg_PARTIDO': 'PT',
        'nm_PARTIDO': 'Partido',
        'urlFoto': 'url',
        'candidatoApto': true,
      });
      expect(strDto.ballotNumber, equals(13));

      final numDto = RunningMateDto.fromJson(const {
        'sq_CANDIDATO': 102,
        'nr_CANDIDATO': 15,
        'nm_URNA': 'VICE 2',
        'nm_CANDIDATO': 'NOME VICE 2',
        'ds_CARGO': 'Vice',
        'sg_PARTIDO': 'MDB',
        'nm_PARTIDO': 'Partido',
        'urlFoto': 'url',
        'candidatoApto': true,
      });
      expect(numDto.ballotNumber, equals(15));
    });

    test('CandidateFileDto deve identificar propostas com codTipo igual a 5', () {
      final proposal = CandidateFileDto.fromJson(const {
        'idArquivo': 901,
        'nome': 'plano.pdf',
        'url': 'path/',
        'tipo': 'pdf',
        'codTipo': '5',
      });
      expect(proposal.isGovernmentProposal, isTrue);

      final certidao = CandidateFileDto.fromJson(const {
        'idArquivo': 902,
        'nome': 'certidao.pdf',
        'url': 'path/',
        'tipo': 'pdf',
        'codTipo': '11',
      });
      expect(certidao.isGovernmentProposal, isFalse);
    });

    test('CandidateListItemDto deve serializar e desserializar com integridade', () {
      const json = {
        'id': 280001612393,
        'numero': 12,
        'nomeUrna': 'CIRO',
        'nomeCompleto': 'CIRO GOMES',
        'descricaoSituacao': 'Deferido',
        'candidatoApto': true,
        'st_REELEICAO': false,
        'nomeColigacao': 'PDT',
        'cargo': {'codigo': 1, 'nome': 'Presidente'},
        'partido': {'numero': 12, 'sigla': 'PDT', 'nome': 'Partido'},
        'totalDeBens': 1000000.0,
        'fotoUrl': 'url',
      };
      final dto = CandidateListItemDto.fromJson(json);

      expect(dto.id, equals(280001612393));
      expect(dto.ballotNumber, equals(12));
      expect(dto.roleCode, equals(1));
      expect(dto.partyNumber, equals(12));
      expect(dto.toJson(), equals(json));
    });
  });
}
