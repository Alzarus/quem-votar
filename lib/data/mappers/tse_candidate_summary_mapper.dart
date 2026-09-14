import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/registration_status_parser.dart';
import 'package:quem_votar/data/mappers/tse_url_builder.dart';
import 'package:quem_votar/data/models/candidate_list_item_dto.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';

/// Mapper responsavel pela conversao de dados sinteticos de candidatos da listagem.
///
/// Transforma [CandidateListItemDto], [CandidateData] (Drift) e [CandidateSummary] (Dominio).
abstract final class TseCandidateSummaryMapper {
  /// Converte DTO em entidade [CandidateSummary], compondo URLs de foto quando nulas.
  static CandidateSummary fromDto(
    CandidateListItemDto dto, {
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
    final partyName = (dto.partyName?.isNotEmpty == true) ? dto.partyName! : dto.partyAcronym;

    return CandidateSummary(
      id: dto.id,
      ballotNumber: dto.ballotNumber,
      ballotName: dto.ballotName,
      fullName: dto.fullName,
      roleCode: dto.roleCode,
      roleDescription: dto.roleName,
      partyAcronym: dto.partyAcronym,
      partyName: partyName,
      coalitionName: dto.coalitionName,
      photoUrl: photoUrl,
      registrationStatus: status,
      rawStatusDescription: dto.rawStatusDescription,
      totalAssetsAmount: dto.totalAssets,
      parentCandidateId: null,
    );
  }

  /// Converte registro relacional [CandidateData] persistido em SQLite para [CandidateSummary].
  static CandidateSummary fromData(CandidateData data) {
    final status = RegistrationStatusParser.fromStorageString(data.status);
    final hasConfirmedAssets = data.detailFetched || data.totalAssets > 0;

    return CandidateSummary(
      id: data.id,
      ballotNumber: data.ballotNumber,
      ballotName: data.ballotName,
      fullName: data.fullName,
      roleCode: data.roleCode,
      roleDescription: data.roleDescription,
      partyAcronym: data.partyAcronym,
      partyName: data.partyName,
      coalitionName: data.coalitionName,
      photoUrl: data.photoUrl,
      registrationStatus: status,
      rawStatusDescription: data.rawStatus,
      totalAssetsAmount: hasConfirmedAssets ? data.totalAssets : null,
      parentCandidateId: data.parentCandidateId,
    );
  }

  /// Converte DTO em registro relacional [CandidatesTableCompanion] para persistencia em lote.
  static CandidatesTableCompanion toCompanion(
    CandidateListItemDto dto, {
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
    final partyName = (dto.partyName?.isNotEmpty == true) ? dto.partyName! : dto.partyAcronym;

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
      partyName: Value(partyName),
      coalitionName: Value(dto.coalitionName),
      coalitionComp: Value(dto.coalitionName),
      status: Value(RegistrationStatusParser.toStorageString(status)),
      rawStatus: Value(dto.rawStatusDescription),
      totalAssets: Value(dto.totalAssets ?? 0.0),
      photoUrl: Value(photoUrl),
      detailFetched: const Value(false),
    );
  }

  /// Resolve endereco de imagem garantindo composicao da URL oficial quando omitida pela API.
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
