import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/registration_status_parser.dart';
import 'package:quem_votar/data/mappers/tse_asset_mapper.dart';
import 'package:quem_votar/data/mappers/tse_running_mate_mapper.dart';
import 'package:quem_votar/data/mappers/tse_url_builder.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';

/// Mapper responsavel pela consolidacao de fichas cadastrais completas de candidatos.
///
/// Transforma [CandidateDetailDto], tabelas relacionais do Drift e a entidade [CandidateDetail].
abstract final class TseCandidateDetailMapper {
  /// Converte o DTO retornado pelo endpoint de detalhe na entidade [CandidateDetail].
  static CandidateDetail fromDto(
    CandidateDetailDto dto, {
    required int electionId,
    required String ufOrMun,
  }) {
    final status = RegistrationStatusParser.parse(dto.rawStatusDescription);
    final photoUrl = _resolvePhotoUrl(
      dtoPhotoUrl: dto.photoUrl,
      electionId: electionId,
      candidateId: dto.id,
      ufOrMun: ufOrMun,
    );
    final proposalUrl = _extractProposalDocumentUrl(dto);

    return CandidateDetail(
      id: dto.id,
      ballotNumber: dto.ballotNumber,
      ballotName: dto.ballotName,
      fullName: dto.fullName,
      roleCode: dto.roleCode,
      roleDescription: dto.roleName,
      partyAcronym: dto.partyAcronym,
      partyName: dto.partyName,
      coalitionName: dto.coalitionName,
      photoUrl: photoUrl,
      registrationStatus: status,
      rawStatusDescription: dto.rawStatusDescription,
      totalAssetsAmount: dto.totalAssets,
      parentCandidateId: null,
      birthDate: dto.birthDate,
      gender: dto.gender,
      colorRace: dto.colorRace,
      maritalStatus: dto.maritalStatus,
      educationLevel: dto.educationLevel,
      occupation: dto.occupation,
      nationality: dto.nationality,
      birthCity: dto.birthCity,
      birthState: dto.birthState,
      maxCampaignExpenseFirstTurn: dto.maxExpenseFirstTurn,
      maxCampaignExpenseSecondTurn: dto.maxExpenseSecondTurn,
      assets: dto.assets.map(TseAssetMapper.fromDto).toList(growable: false),
      runningMates: dto.runningMates.map(TseRunningMateMapper.fromDto).toList(growable: false),
      proposalDocumentUrl: proposalUrl,
    );
  }

  /// Recompoe a entidade [CandidateDetail] a partir das tabelas relacionais do Drift.
  static CandidateDetail fromDatabase({
    required CandidateData candidate,
    required List<CandidateAssetData> assets,
    required List<CandidateData> runningMates,
  }) {
    final status = RegistrationStatusParser.fromStorageString(candidate.status);

    return CandidateDetail(
      id: candidate.id,
      ballotNumber: candidate.ballotNumber,
      ballotName: candidate.ballotName,
      fullName: candidate.fullName,
      roleCode: candidate.roleCode,
      roleDescription: candidate.roleDescription,
      partyAcronym: candidate.partyAcronym,
      partyName: candidate.partyName,
      coalitionName: candidate.coalitionName,
      photoUrl: candidate.photoUrl,
      registrationStatus: status,
      rawStatusDescription: candidate.rawStatus,
      totalAssetsAmount: candidate.totalAssets,
      parentCandidateId: candidate.parentCandidateId,
      birthDate: candidate.birthDate ?? '',
      gender: candidate.gender ?? '',
      colorRace: candidate.colorRace ?? '',
      maritalStatus: candidate.maritalStatus ?? '',
      educationLevel: candidate.educationLevel ?? '',
      occupation: candidate.occupation ?? '',
      nationality: candidate.nationality ?? '',
      birthCity: candidate.birthCity ?? '',
      birthState: candidate.birthState ?? '',
      maxCampaignExpenseFirstTurn: candidate.maxExpense1t ?? 0.0,
      maxCampaignExpenseSecondTurn: candidate.maxExpense2t,
      assets: assets.map(TseAssetMapper.fromData).toList(growable: false),
      runningMates: runningMates.map(TseRunningMateMapper.fromData).toList(growable: false),
      proposalDocumentUrl: candidate.proposalDocUrl,
    );
  }

  /// Converte DTO em registro relacional [CandidatesTableCompanion] com os campos detalhados.
  static CandidatesTableCompanion toCompanion(
    CandidateDetailDto dto, {
    required int electionId,
    required String stateCode,
    int? cityCode,
  }) {
    final status = RegistrationStatusParser.parse(dto.rawStatusDescription);
    final photoUrl = _resolvePhotoUrl(
      dtoPhotoUrl: dto.photoUrl,
      electionId: electionId,
      candidateId: dto.id,
      ufOrMun: stateCode,
    );
    final proposalUrl = _extractProposalDocumentUrl(dto);

    return CandidatesTableCompanion(
      id: Value(dto.id),
      electionId: Value(electionId),
      stateCode: Value(stateCode),
      cityCode: Value(cityCode),
      roleCode: Value(dto.roleCode),
      roleDescription: Value(dto.roleName),
      ballotNumber: Value(dto.ballotNumber),
      ballotName: Value(dto.ballotName),
      fullName: Value(dto.fullName),
      partyNumber: Value(dto.partyNumber),
      partyAcronym: Value(dto.partyAcronym),
      partyName: Value(dto.partyName),
      coalitionName: Value(dto.coalitionName),
      coalitionComp: Value(dto.coalitionName),
      status: Value(RegistrationStatusParser.toStorageString(status)),
      rawStatus: Value(dto.rawStatusDescription),
      totalAssets: Value(dto.totalAssets),
      photoUrl: Value(photoUrl),
      birthDate: Value(dto.birthDate),
      gender: Value(dto.gender),
      colorRace: Value(dto.colorRace),
      maritalStatus: Value(dto.maritalStatus),
      educationLevel: Value(dto.educationLevel),
      occupation: Value(dto.occupation),
      nationality: Value(dto.nationality),
      birthCity: Value(dto.birthCity),
      birthState: Value(dto.birthState),
      maxExpense1t: Value(dto.maxExpenseFirstTurn),
      maxExpense2t: Value(dto.maxExpenseSecondTurn),
      proposalDocUrl: Value(proposalUrl),
      detailFetched: const Value(true),
    );
  }

  /// Extrai endereco da proposta de governo identificando arquivos com `codTipo == '5'`.
  static String? _extractProposalDocumentUrl(CandidateDetailDto dto) {
    for (final file in dto.files) {
      if (file.isGovernmentProposal) {
        return TseUrlBuilder.buildProposalDocumentUrl(file.fileId);
      }
    }
    return null;
  }

  /// Resolve endereco de fotografia de urna em alta resolucao.
  static String _resolvePhotoUrl({
    required String? dtoPhotoUrl,
    required int electionId,
    required int candidateId,
    required String ufOrMun,
  }) {
    if (dtoPhotoUrl != null && dtoPhotoUrl.trim().isNotEmpty) {
      return dtoPhotoUrl.trim();
    }
    return TseUrlBuilder.buildUrnaPhotoUrl(
      electionId: electionId,
      candidateId: candidateId,
      ufOrMun: ufOrMun,
    );
  }
}
