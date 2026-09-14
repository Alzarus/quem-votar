import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/registration_status_parser.dart';
import 'package:quem_votar/data/models/running_mate_dto.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';

/// Mapper responsavel pela conversao de integrantes de chapa majoritaria (vices/suplentes).
///
/// Realiza a transformacao entre [RunningMateDto], [CandidateData] (Drift) e [RunningMate] (Dominio).
abstract final class TseRunningMateMapper {
  /// Converte instancia de DTO para a entidade pura [RunningMate].
  static RunningMate fromDto(RunningMateDto dto) {
    return RunningMate(
      id: dto.candidateId,
      parentCandidateId: dto.parentCandidateId,
      ballotNumber: dto.ballotNumber,
      ballotName: dto.ballotName,
      fullName: dto.fullName,
      partyAcronym: dto.partyAcronym,
      partyName: dto.partyName,
      roleDescription: dto.roleDescription,
      photoUrl: dto.photoUrl,
      isEligible: dto.isEligible,
    );
  }

  /// Converte registro relacional persistido na tabela `candidates` para [RunningMate].
  static RunningMate fromData(CandidateData data) {
    final status = RegistrationStatusParser.fromStorageString(data.status);
    return RunningMate(
      id: data.id,
      parentCandidateId: data.parentCandidateId,
      ballotNumber: data.ballotNumber,
      ballotName: data.ballotName,
      fullName: data.fullName,
      partyAcronym: data.partyAcronym,
      partyName: data.partyName,
      roleDescription: data.roleDescription,
      photoUrl: data.photoUrl,
      isEligible: status.isEligibleToVote,
    );
  }

  /// Converte DTO em registro para persistencia relacional na tabela de candidatos.
  static CandidatesTableCompanion toCompanion(
    RunningMateDto dto, {
    required int electionId,
    required String stateCode,
  }) {
    final status = dto.isEligible ? 'DEFERRED' : 'INELIGIBLE';
    final rawStatus = dto.isEligible ? 'Deferido' : 'Indeferido';

    return CandidatesTableCompanion(
      id: Value(dto.candidateId),
      electionId: Value(electionId),
      stateCode: Value(stateCode),
      parentCandidateId: Value(dto.parentCandidateId),
      roleCode: const Value(0),
      roleDescription: Value(dto.roleDescription),
      ballotNumber: Value(dto.ballotNumber),
      ballotName: Value(dto.ballotName),
      fullName: Value(dto.fullName),
      partyNumber: const Value(0),
      partyAcronym: Value(dto.partyAcronym),
      partyName: Value(dto.partyName),
      coalitionName: const Value(''),
      coalitionComp: const Value(''),
      status: Value(status),
      rawStatus: Value(rawStatus),
      totalAssets: const Value(0.0),
      photoUrl: Value(dto.photoUrl),
      detailFetched: const Value(false),
    );
  }
}
