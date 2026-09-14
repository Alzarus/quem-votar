import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/tse_running_mate_mapper.dart';
import 'package:quem_votar/data/models/running_mate_dto.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';

void main() {
  group('TseRunningMateMapper - Mapeamento de Vices e Suplentes', () {
    test('deve converter RunningMateDto em entidade RunningMate', () {
      const dto = RunningMateDto(
        candidateId: 280001612392,
        parentCandidateId: 280001612393,
        ballotNumber: 12,
        ballotName: 'ANA PAULA MATOS',
        fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
        roleDescription: 'Vice-presidente',
        partyAcronym: 'PDT',
        partyName: 'Partido Democratico Trabalhista',
        photoUrl: 'https://exemplo.tse.jus.br/foto_ana.jpg',
        isEligible: true,
      );

      final entity = TseRunningMateMapper.fromDto(dto);

      expect(entity, isA<RunningMate>());
      expect(entity.id, equals(280001612392));
      expect(entity.parentCandidateId, equals(280001612393));
      expect(entity.ballotNumber, equals(12));
      expect(entity.ballotName, equals('ANA PAULA MATOS'));
      expect(entity.fullName, equals('ANA PAULA ANDRADE MATOS MOREIRA'));
      expect(entity.roleDescription, equals('Vice-presidente'));
      expect(entity.partyAcronym, equals('PDT'));
      expect(entity.partyName, equals('Partido Democratico Trabalhista'));
      expect(entity.isEligible, isTrue);
    });

    test('deve converter CandidateData do Drift em RunningMate', () {
      const data = CandidateData(
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
        photoUrl: 'https://exemplo.tse.jus.br/foto_ana.jpg',
        parentCandidateId: 280001612393,
        detailFetched: false,
      );

      final entity = TseRunningMateMapper.fromData(data);

      expect(entity.id, equals(280001612392));
      expect(entity.parentCandidateId, equals(280001612393));
      expect(entity.ballotName, equals('ANA PAULA MATOS'));
      expect(entity.isEligible, isTrue);
    });

    test('deve converter RunningMateDto em CandidatesTableCompanion para Drift', () {
      const dto = RunningMateDto(
        candidateId: 280001612392,
        parentCandidateId: 280001612393,
        ballotNumber: 12,
        ballotName: 'ANA PAULA MATOS',
        fullName: 'ANA PAULA ANDRADE MATOS MOREIRA',
        roleDescription: 'Vice-presidente',
        partyAcronym: 'PDT',
        partyName: 'Partido Democratico Trabalhista',
        photoUrl: 'https://exemplo.tse.jus.br/foto_ana.jpg',
        isEligible: true,
      );

      final companion = TseRunningMateMapper.toCompanion(
        dto,
        electionId: 20322002026,
        stateCode: 'BR',
      );

      expect(companion.id.value, equals(280001612392));
      expect(companion.parentCandidateId.value, equals(280001612393));
      expect(companion.electionId.value, equals(20322002026));
      expect(companion.status.value, equals('DEFERRED'));
      expect(companion.rawStatus.value, equals('Deferido'));
    });
  });
}
