import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/tse_candidate_summary_mapper.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/models/candidate_list_item_dto.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  group('TseCandidateSummaryMapper - Mapeamento Sintetico de Candidaturas', () {
    late Map<String, dynamic> fixtureMap;

    setUp(() {
      fixtureMap = TseFixtureReader.readJsonMap('candidatos_presidente_2026.json');
    });

    test('deve converter DTO da fixture oficial resolvendo photoUrl quando nula', () {
      final envelope = CandidateListEnvelopeDto.fromJson(fixtureMap);
      final firstCandidate = envelope.candidates.first;

      final summary = TseCandidateSummaryMapper.fromDto(
        firstCandidate,
        electionId: 20322002026,
        ufOrMun: 'BR',
      );

      expect(summary, isA<CandidateSummary>());
      expect(summary.id, equals(280001612393));
      expect(summary.ballotNumber, equals(12));
      expect(summary.ballotName, equals('CIRO GOMES'));
      expect(summary.fullName, equals('CIRO FERREIRA GOMES'));
      expect(summary.roleCode, equals(1));
      expect(summary.roleDescription, equals('Presidente'));
      expect(summary.partyAcronym, equals('PDT'));
      expect(summary.partyName, equals('PDT')); // quando nome nulo, usa sigla
      expect(summary.registrationStatus, equals(RegistrationStatus.deferred));
      expect(summary.rawStatusDescription, equals('Deferido'));
      expect(summary.totalAssetsAmount, isNull);
      expect(
        summary.photoUrl,
        equals(
          'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/20322002026/280001612393/BR',
        ),
      );
    });

    test('deve preservar photoUrl explicita caso fornecida pelo DTO', () {
      const dto = CandidateListItemDto(
        id: 12345,
        ballotNumber: 99,
        ballotName: 'NOME URNA',
        fullName: 'NOME COMPLETO',
        rawStatusDescription: 'Deferido',
        isEligible: true,
        isReelection: false,
        coalitionName: 'COLIGACAO',
        roleCode: 1,
        roleName: 'Presidente',
        partyNumber: 99,
        partyAcronym: 'SIGLA',
        photoUrl: 'https://servidor.customizado/foto.jpg',
      );

      final summary = TseCandidateSummaryMapper.fromDto(
        dto,
        electionId: 20322002026,
        ufOrMun: 'BR',
      );

      expect(summary.photoUrl, equals('https://servidor.customizado/foto.jpg'));
    });

    test('deve converter CandidateData do Drift em CandidateSummary', () {
      const data = CandidateData(
        id: 280001607829,
        electionId: 20322002026,
        stateCode: 'BR',
        roleCode: 1,
        roleDescription: 'Presidente',
        ballotNumber: 13,
        ballotName: 'LULA',
        fullName: 'LUIZ INACIO LULA DA SILVA',
        partyNumber: 13,
        partyAcronym: 'PT',
        partyName: 'PARTIDO DOS TRABALHADORES',
        coalitionName: 'FE BRASIL',
        coalitionComp: 'FE BRASIL (PT/PC do B/PV)',
        status: 'DEFERRED',
        rawStatus: 'Deferido',
        totalAssets: 7423625.38,
        photoUrl: 'https://exemplo.tse.jus.br/foto.jpg',
        detailFetched: false,
      );

      final summary = TseCandidateSummaryMapper.fromData(data);

      expect(summary.id, equals(280001607829));
      expect(summary.ballotName, equals('LULA'));
      expect(summary.registrationStatus, equals(RegistrationStatus.deferred));
      expect(summary.totalAssetsAmount, equals(7423625.38));
    });

    test('deve converter CandidateListItemDto em CandidatesTableCompanion para Drift', () {
      const dto = CandidateListItemDto(
        id: 280001612393,
        ballotNumber: 12,
        ballotName: 'CIRO GOMES',
        fullName: 'CIRO FERREIRA GOMES',
        rawStatusDescription: 'Deferido',
        isEligible: true,
        isReelection: false,
        coalitionName: 'PDT',
        roleCode: 1,
        roleName: 'Presidente',
        partyNumber: 12,
        partyAcronym: 'PDT',
        totalAssets: 3039761.97,
      );

      final companion = TseCandidateSummaryMapper.toCompanion(
        dto,
        electionId: 20322002026,
        stateCode: 'BR',
      );

      expect(companion.id.value, equals(280001612393));
      expect(companion.electionId.value, equals(20322002026));
      expect(companion.stateCode.value, equals('BR'));
      expect(companion.status.value, equals('DEFERRED'));
      expect(companion.totalAssets.value, equals(3039761.97));
      expect(companion.detailFetched.value, isFalse);
    });
  });
}
