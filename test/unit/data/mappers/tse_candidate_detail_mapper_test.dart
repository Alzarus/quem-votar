import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/tse_candidate_detail_mapper.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  group('TseCandidateDetailMapper - Mapeamento Consolidado de Ficha Cadastral', () {
    late Map<String, dynamic> fixtureMap;

    setUp(() {
      fixtureMap = TseFixtureReader.readJsonMap('candidato_detalhe_completo.json');
    });

    test('deve converter DTO da fixture oficial consolidando bens, vices e proposta', () {
      final dto = CandidateDetailDto.fromJson(fixtureMap);

      final detail = TseCandidateDetailMapper.fromDto(dto, electionId: 20322002026, ufOrMun: 'BR');

      expect(detail, isA<CandidateDetail>());
      expect(detail.id, equals(280001612393));
      expect(detail.ballotNumber, equals(12));
      expect(detail.ballotName, equals('CIRO GOMES'));
      expect(detail.fullName, equals('CIRO FERREIRA GOMES'));
      expect(detail.birthDate, equals('1957-11-06'));
      expect(detail.gender, equals('MASC.'));
      expect(detail.colorRace, equals('BRANCA'));
      expect(detail.maritalStatus, equals('Divorciado(a)'));
      expect(detail.educationLevel, equals('Superior completo'));
      expect(detail.occupation, equals('Advogado'));
      expect(detail.nationality, equals('Brasileira nata'));
      expect(detail.birthCity, equals('PINDAMONHANGABA'));
      expect(detail.birthState, equals('SP'));
      expect(detail.maxCampaignExpenseFirstTurn, equals(88944030.80));
      expect(detail.maxCampaignExpenseSecondTurn, equals(44472015.40));
      expect(detail.totalAssetsAmount, equals(3039761.97));
      expect(detail.registrationStatus, equals(RegistrationStatus.deferred));

      // Verificacao de Bens declarados
      expect(detail.assets.length, equals(2));
      expect(detail.assets.first.orderIndex, equals(1));
      expect(detail.assets.first.category, equals('Apartamento'));
      expect(detail.assets.first.amount, equals(687091.02));
      expect(detail.assets[1].orderIndex, equals(2));
      expect(detail.assets[1].amount, equals(105000.00));

      // Verificacao de Vices na chapa
      expect(detail.runningMates.length, equals(1));
      expect(detail.runningMates.first.id, equals(280001612392));
      expect(detail.runningMates.first.ballotName, equals('ANA PAULA MATOS'));
      expect(detail.runningMates.first.isEligible, isTrue);

      // Verificacao de Proposta de Governo extraida de arquivos[] (codTipo == '5')
      expect(
        detail.proposalDocumentUrl,
        equals('https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/doc/280010929672'),
      );
    });

    test('deve reconstituir CandidateDetail a partir das tabelas relacionais do Drift', () {
      const candidateData = CandidateData(
        id: 280001612393,
        electionId: 20322002026,
        stateCode: 'BR',
        roleCode: 1,
        roleDescription: 'Presidente',
        ballotNumber: 12,
        ballotName: 'CIRO GOMES',
        fullName: 'CIRO FERREIRA GOMES',
        partyNumber: 12,
        partyAcronym: 'PDT',
        partyName: 'Partido Democratico Trabalhista',
        coalitionName: 'PDT',
        coalitionComp: 'PDT',
        status: 'DEFERRED',
        rawStatus: 'Deferido',
        totalAssets: 3039761.97,
        photoUrl: 'https://exemplo.tse.jus.br/foto.jpg',
        birthDate: '1957-11-06',
        gender: 'MASC.',
        colorRace: 'BRANCA',
        maritalStatus: 'Divorciado(a)',
        educationLevel: 'Superior completo',
        occupation: 'Advogado',
        nationality: 'Brasileira nata',
        birthCity: 'PINDAMONHANGABA',
        birthState: 'SP',
        maxExpense1t: 88944030.80,
        maxExpense2t: 44472015.40,
        proposalDocUrl: 'https://exemplo.tse.jus.br/proposta.pdf',
        detailFetched: true,
      );

      const assetData = [
        CandidateAssetData(
          id: 1,
          candidateId: 280001612393,
          orderIndex: 1,
          category: 'Apartamento',
          description: 'APTO',
          amount: 687091.02,
          updatedAt: '2022-08-26',
        ),
      ];

      const viceData = [
        CandidateData(
          id: 280001612392,
          electionId: 20322002026,
          stateCode: 'BR',
          roleCode: 2,
          roleDescription: 'Vice-presidente',
          ballotNumber: 12,
          ballotName: 'ANA PAULA MATOS',
          fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
          partyNumber: 12,
          partyAcronym: 'PDT',
          partyName: 'Partido Democratico Trabalhista',
          coalitionName: 'PDT',
          coalitionComp: 'PDT',
          status: 'DEFERRED',
          rawStatus: 'Deferido',
          totalAssets: 0.0,
          photoUrl: 'https://exemplo.tse.jus.br/foto_vice.jpg',
          parentCandidateId: 280001612393,
          detailFetched: false,
        ),
      ];

      final detail = TseCandidateDetailMapper.fromDatabase(
        candidate: candidateData,
        assets: assetData,
        runningMates: viceData,
      );

      expect(detail.id, equals(280001612393));
      expect(detail.birthCity, equals('PINDAMONHANGABA'));
      expect(detail.assets.length, equals(1));
      expect(detail.runningMates.length, equals(1));
      expect(detail.runningMates.first.ballotName, equals('ANA PAULA MATOS'));
      expect(detail.proposalDocumentUrl, equals('https://exemplo.tse.jus.br/proposta.pdf'));
    });

    test(
      'deve converter CandidateDetailDto em CandidatesTableCompanion com detailFetched=true',
      () {
        final dto = CandidateDetailDto.fromJson(fixtureMap);

        final companion = TseCandidateDetailMapper.toCompanion(
          dto,
          electionId: 20322002026,
          stateCode: 'BR',
        );

        expect(companion.id.value, equals(280001612393));
        expect(companion.electionId.value, equals(20322002026));
        expect(companion.detailFetched.value, isTrue);
        expect(companion.birthDate.value, equals('1957-11-06'));
        expect(companion.occupation.value, equals('Advogado'));
        expect(companion.maxExpense1t.value, equals(88944030.80));
        expect(companion.maxExpense2t.value, equals(44472015.40));
        expect(
          companion.proposalDocUrl.value,
          equals('https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/doc/280010929672'),
        );
      },
    );
  });
}
