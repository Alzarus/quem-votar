import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';

void main() {
  group('Entidades de Dominio - Imutabilidade e Comparacao Estrutural (Equatable)', () {
    test('Election deve suportar comparacao de igualdade por valor', () {
      const election1 = Election(
        id: 20322002026,
        year: 2026,
        name: 'Eleição Geral Federal 2026',
        description: '2026',
        type: 'O',
        scope: 'F',
        electionDate: '2026-10-04',
      );
      const election2 = Election(
        id: 20322002026,
        year: 2026,
        name: 'Eleição Geral Federal 2026',
        description: '2026',
        type: 'O',
        scope: 'F',
        electionDate: '2026-10-04',
      );
      const election3 = Election(
        id: 2040602022,
        year: 2022,
        name: 'Eleição Geral Federal 2022',
        description: '2022',
        type: 'O',
        scope: 'F',
        electionDate: '2022-10-02',
      );

      expect(election1, equals(election2));
      expect(election1, isNot(equals(election3)));
      expect(election1.hashCode, equals(election2.hashCode));
    });

    test('CandidateAsset deve suportar comparacao de igualdade por valor', () {
      const asset1 = CandidateAsset(
        orderIndex: 1,
        category: 'Apartamento',
        description: 'Apartamento residencial 1002',
        amount: 687091.02,
        updatedAt: '2022-08-26',
      );
      const asset2 = CandidateAsset(
        orderIndex: 1,
        category: 'Apartamento',
        description: 'Apartamento residencial 1002',
        amount: 687091.02,
        updatedAt: '2022-08-26',
      );
      const asset3 = CandidateAsset(
        orderIndex: 2,
        category: 'Veículo',
        description: 'Veiculo automotor ano 2020',
        amount: 85000.0,
        updatedAt: '2022-08-26',
      );

      expect(asset1, equals(asset2));
      expect(asset1, isNot(equals(asset3)));
    });

    test('RunningMate deve suportar comparacao de igualdade por valor', () {
      const mate1 = RunningMate(
        id: 280001612392,
        parentCandidateId: 280001612393,
        ballotNumber: 12,
        ballotName: 'ANA PAULA MATOS',
        fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
        partyAcronym: 'PDT',
        partyName: 'Partido Democrático Trabalhista',
        roleDescription: 'Vice-presidente',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/ana.jpg',
        isEligible: true,
      );
      const mate2 = RunningMate(
        id: 280001612392,
        parentCandidateId: 280001612393,
        ballotNumber: 12,
        ballotName: 'ANA PAULA MATOS',
        fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
        partyAcronym: 'PDT',
        partyName: 'Partido Democrático Trabalhista',
        roleDescription: 'Vice-presidente',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/ana.jpg',
        isEligible: true,
      );

      expect(mate1, equals(mate2));
    });

    test('CandidateSummary deve encapsular informacoes sinteticas corretamente', () {
      const summary = CandidateSummary(
        id: 280001612393,
        ballotNumber: 12,
        ballotName: 'CIRO GOMES',
        fullName: 'CIRO FERREIRA GOMES',
        roleCode: 1,
        roleDescription: 'Presidente',
        partyAcronym: 'PDT',
        partyName: 'Partido Democrático Trabalhista',
        coalitionName: 'PDT',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12.jpg',
        registrationStatus: RegistrationStatus.deferred,
        rawStatusDescription: 'Deferido',
        totalAssetsAmount: 3039761.97,
      );

      expect(summary.ballotName, equals('CIRO GOMES'));
      expect(summary.registrationStatus.isEligibleToVote, isTrue);
      expect(summary.parentCandidateId, isNull);
    });

    test('CandidateDetail deve estender CandidateSummary preservando hierarquia de tipos', () {
      const detail = CandidateDetail(
        id: 280001612393,
        ballotNumber: 12,
        ballotName: 'CIRO GOMES',
        fullName: 'CIRO FERREIRA GOMES',
        roleCode: 1,
        roleDescription: 'Presidente',
        partyAcronym: 'PDT',
        partyName: 'Partido Democrático Trabalhista',
        coalitionName: 'PDT',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12.jpg',
        registrationStatus: RegistrationStatus.deferred,
        rawStatusDescription: 'Deferido',
        totalAssetsAmount: 3039761.97,
        birthDate: '1957-11-06',
        gender: 'MASC.',
        colorRace: 'BRANCA',
        maritalStatus: 'Divorciado(a)',
        educationLevel: 'Superior completo',
        occupation: 'Advogado',
        nationality: 'Brasileira nata',
        birthCity: 'PINDAMONHANGABA',
        birthState: 'SP',
        maxCampaignExpenseFirstTurn: 88944030.8,
        maxCampaignExpenseSecondTurn: 44472015.4,
        assets: [
          CandidateAsset(
            orderIndex: 1,
            category: 'Apartamento',
            description: 'Apartamento residencial',
            amount: 687091.02,
            updatedAt: '2022-08-26',
          ),
        ],
        runningMates: [
          RunningMate(
            id: 280001612392,
            ballotNumber: 12,
            ballotName: 'ANA PAULA MATOS',
            fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
            partyAcronym: 'PDT',
            partyName: 'Partido Democrático Trabalhista',
            roleDescription: 'Vice-presidente',
            photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/ana.jpg',
            isEligible: true,
          ),
        ],
        proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta.pdf',
      );

      expect(detail, isA<CandidateSummary>());
      expect(detail.assets.length, equals(1));
      expect(detail.runningMates.length, equals(1));
      expect(detail.proposalDocumentUrl, isNotNull);
      expect(detail.maxCampaignExpenseSecondTurn, equals(44472015.4));
    });
  });
}
