import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/models/candidate_asset_dto.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/models/candidate_list_item_dto.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/data/models/running_mate_dto.dart';
import 'package:quem_votar/data/repositories/tse_cache_hasher.dart';

void main() {
  group('TseCacheHasher - hashCandidateList', () {
    CandidateListEnvelopeDto createEnvelope({
      String status = 'Deferido',
      double? totalAssets = 150000.0,
      int candidateId = 1001,
    }) {
      return CandidateListEnvelopeDto(
        stateCode: 'BR',
        stateName: 'Brasil',
        roleCode: 1,
        roleName: 'Presidente',
        candidates: [
          CandidateListItemDto(
            id: candidateId,
            ballotNumber: 13,
            ballotName: 'Candidato Teste',
            fullName: 'Candidato Teste Completo',
            partyNumber: 13,
            partyAcronym: 'PT',
            partyName: 'Partido dos Trabalhadores',
            roleCode: 1,
            roleName: 'Presidente',
            coalitionName: 'Coligacao Uniao',
            photoUrl: 'https://exemplo.tse.jus.br/foto.jpg',
            rawStatusDescription: status,
            totalAssets: totalAssets,
            isEligible: true,
            isReelection: false,
          ),
        ],
      );
    }

    test('deve produzir hash SHA-256 hexadecimal valido de 64 caracteres', () {
      final envelope = createEnvelope();
      final hash = TseCacheHasher.hashCandidateList(envelope);

      expect(hash.length, equals(64));
      expect(RegExp(r'^[a-f0-9]{64}$').hasMatch(hash), isTrue);
    });

    test('deve produzir mesmo hash para objetos com mesmos dados', () {
      final envelope1 = createEnvelope();
      final envelope2 = createEnvelope();

      expect(
        TseCacheHasher.hashCandidateList(envelope1),
        equals(TseCacheHasher.hashCandidateList(envelope2)),
      );
    });

    test('deve produzir hashes distintos ao alterar situacao juridica do candidato', () {
      final envelopeOriginal = createEnvelope(status: 'Deferido');
      final envelopeAlterado = createEnvelope(status: 'Indeferido com recurso');

      final hashOriginal = TseCacheHasher.hashCandidateList(envelopeOriginal);
      final hashAlterado = TseCacheHasher.hashCandidateList(envelopeAlterado);

      expect(hashOriginal, isNot(equals(hashAlterado)));
    });

    test('deve produzir hashes distintos ao alterar patrimonio total', () {
      final envelopeOriginal = createEnvelope(totalAssets: 100000.0);
      final envelopeAlterado = createEnvelope(totalAssets: 200000.0);

      final hashOriginal = TseCacheHasher.hashCandidateList(envelopeOriginal);
      final hashAlterado = TseCacheHasher.hashCandidateList(envelopeAlterado);

      expect(hashOriginal, isNot(equals(hashAlterado)));
    });
  });

  group('TseCacheHasher - hashCandidateDetail', () {
    CandidateDetailDto createDetail({
      double totalAssets = 500000.0,
      List<CandidateAssetDto> assets = const [],
    }) {
      return CandidateDetailDto(
        id: 280001607820,
        ballotNumber: 13,
        ballotName: 'Lula',
        fullName: 'Luiz Inacio Lula da Silva',
        partyNumber: 13,
        partyAcronym: 'PT',
        partyName: 'Partido dos Trabalhadores',
        roleCode: 1,
        roleName: 'Presidente',
        coalitionName: 'Brasil da Esperanca',
        photoUrl: 'https://exemplo.tse.jus.br/foto.jpg',
        rawStatusDescription: 'Deferido',
        totalAssets: totalAssets,
        birthDate: '1945-10-27',
        gender: 'MASCULINO',
        colorRace: 'BRANCA',
        maritalStatus: 'CASADO(A)',
        educationLevel: 'ENSINO FUNDAMENTAL INCOMPLETO',
        occupation: 'APOSENTADO (EXCETO SERVIDOR PUBLICO)',
        nationality: 'BRASILEIRA NATA',
        birthCity: 'Garanhuns',
        birthState: 'PE',
        maxExpenseFirstTurn: 88000000.0,
        maxExpenseSecondTurn: 44000000.0,
        assets: assets,
        runningMates: const [
          RunningMateDto(
            candidateId: 280001607821,
            parentCandidateId: 280001607820,
            ballotNumber: 13,
            ballotName: 'Geraldo Alckmin',
            fullName: 'Geraldo Jose Rodrigues Alckmin Filho',
            partyAcronym: 'PSB',
            partyName: 'Partido Socialista Brasileiro',
            roleDescription: 'Vice-Presidente',
            photoUrl: 'https://exemplo.tse.jus.br/vice.jpg',
            isEligible: true,
          ),
        ],
        files: const [],
        isEligible: true,
        isReelection: false,
      );
    }

    test('deve produzir hash SHA-256 valido de 64 caracteres para detalhe', () {
      final detail = createDetail();
      final hash = TseCacheHasher.hashCandidateDetail(detail);

      expect(hash.length, equals(64));
      expect(RegExp(r'^[a-f0-9]{64}$').hasMatch(hash), isTrue);
    });

    test('deve produzir hashes distintos ao modificar bens declarados', () {
      final detailSemBens = createDetail(assets: const []);
      final detailComBens = createDetail(
        assets: const [
          CandidateAssetDto(
            orderIndex: 1,
            category: 'Apartamento',
            description: 'Apartamento residencial',
            amount: 500000.0,
            updatedAt: '2026-08-15',
          ),
        ],
      );

      final hash1 = TseCacheHasher.hashCandidateDetail(detailSemBens);
      final hash2 = TseCacheHasher.hashCandidateDetail(detailComBens);

      expect(hash1, isNot(equals(hash2)));
    });
  });

  group('TseCacheHasher - hashElections', () {
    test('deve produzir hashes deterministicos e detectar alteracao em lista de pleitos', () {
      const e1 = ElectionDto(
        id: 20322002026,
        year: 2026,
        name: 'Eleicoes Gerais 2026',
        description: 'Eleicao Ordinaria Geral 2026',
        type: 'Ordinaria',
        scope: 'Federal',
        electionDate: '2026-10-04',
      );
      const e2 = ElectionDto(
        id: 20322002022,
        year: 2022,
        name: 'Eleicoes Gerais 2022',
        description: 'Eleicao Ordinaria Geral 2022',
        type: 'Ordinaria',
        scope: 'Federal',
        electionDate: '2022-10-02',
      );

      final hashA = TseCacheHasher.hashElections([e1]);
      final hashB = TseCacheHasher.hashElections([e1, e2]);

      expect(hashA.length, equals(64));
      expect(hashB.length, equals(64));
      expect(hashA, isNot(equals(hashB)));
    });
  });
}
