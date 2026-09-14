import 'package:equatable/equatable.dart';
import 'package:quem_votar/data/models/candidate_asset_dto.dart';
import 'package:quem_votar/data/models/candidate_file_dto.dart';
import 'package:quem_votar/data/models/running_mate_dto.dart';

/// DTO com os atributos completos retornados no detalhe da candidatura pelo TSE.
///
/// Mapeia o payload integral da rota `/candidatura/buscar/.../candidato/{idCandidato}`.
class CandidateDetailDto extends Equatable {
  final int id;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final String gender;
  final String birthDate;
  final String maritalStatus;
  final String colorRace;
  final String rawStatusDescription;
  final String nationality;
  final String educationLevel;
  final String occupation;
  final double maxExpenseFirstTurn;
  final double? maxExpenseSecondTurn;
  final double totalAssets;
  final String photoUrl;
  final bool isEligible;
  final bool isReelection;
  final String birthState;
  final String birthCity;
  final String coalitionName;
  final int roleCode;
  final String roleName;
  final int partyNumber;
  final String partyAcronym;
  final String partyName;
  final List<CandidateAssetDto> assets;
  final List<RunningMateDto> runningMates;
  final List<CandidateFileDto> files;

  const CandidateDetailDto({
    required this.id,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.maritalStatus,
    required this.colorRace,
    required this.rawStatusDescription,
    required this.nationality,
    required this.educationLevel,
    required this.occupation,
    required this.maxExpenseFirstTurn,
    this.maxExpenseSecondTurn,
    required this.totalAssets,
    required this.photoUrl,
    required this.isEligible,
    required this.isReelection,
    required this.birthState,
    required this.birthCity,
    required this.coalitionName,
    required this.roleCode,
    required this.roleName,
    required this.partyNumber,
    required this.partyAcronym,
    required this.partyName,
    required this.assets,
    required this.runningMates,
    required this.files,
  });

  /// Instancia DTO consolidado com conversao defensiva para listas e campos nulos.
  factory CandidateDetailDto.fromJson(Map<String, dynamic> json) {
    final cargoMap = json['cargo'] as Map<String, dynamic>? ?? {};
    final partidoMap = json['partido'] as Map<String, dynamic>? ?? {};

    return CandidateDetailDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ballotNumber: (json['numero'] as num?)?.toInt() ?? 0,
      ballotName: json['nomeUrna'] as String? ?? '',
      fullName: json['nomeCompleto'] as String? ?? '',
      gender: json['descricaoSexo'] as String? ?? '',
      birthDate: json['dataDeNascimento'] as String? ?? '',
      maritalStatus: json['descricaoEstadoCivil'] as String? ?? '',
      colorRace: json['descricaoCorRaca'] as String? ?? '',
      rawStatusDescription: json['descricaoSituacao'] as String? ?? '',
      nationality: json['nacionalidade'] as String? ?? '',
      educationLevel: json['grauInstrucao'] as String? ?? '',
      occupation: json['ocupacao'] as String? ?? '',
      maxExpenseFirstTurn: _parseDouble(json['gastoCampanha1T']),
      maxExpenseSecondTurn: _parseOptionalDouble(json['gastoCampanha2T']),
      totalAssets: _parseDouble(json['totalDeBens']),
      photoUrl: json['fotoUrl'] as String? ?? '',
      isEligible: json['candidatoApto'] as bool? ?? true,
      isReelection: json['st_REELEICAO'] as bool? ?? false,
      birthState: json['sgUfNascimento'] as String? ?? '',
      birthCity: json['nomeMunicipioNascimento'] as String? ?? '',
      coalitionName: json['nomeColigacao'] as String? ?? '',
      roleCode: (cargoMap['codigo'] as num?)?.toInt() ?? 0,
      roleName: cargoMap['nome'] as String? ?? '',
      partyNumber: (partidoMap['numero'] as num?)?.toInt() ?? 0,
      partyAcronym: partidoMap['sigla'] as String? ?? '',
      partyName: partidoMap['nome'] as String? ?? '',
      assets: _parseAssets(json['bens']),
      runningMates: _parseRunningMates(json['vices']),
      files: _parseFiles(json['arquivos']),
    );
  }

  static double _parseDouble(Object? raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw.replaceAll(',', '.')) ?? 0.0;
    return 0.0;
  }

  static double? _parseOptionalDouble(Object? raw) {
    if (raw == null) return null;
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw.replaceAll(',', '.'));
    return null;
  }

  static List<CandidateAssetDto> _parseAssets(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CandidateAssetDto.fromJson)
        .toList(growable: false);
  }

  static List<RunningMateDto> _parseRunningMates(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(RunningMateDto.fromJson)
        .toList(growable: false);
  }

  static List<CandidateFileDto> _parseFiles(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CandidateFileDto.fromJson)
        .toList(growable: false);
  }

  @override
  List<Object?> get props => [
    id,
    ballotNumber,
    ballotName,
    fullName,
    gender,
    birthDate,
    maritalStatus,
    colorRace,
    rawStatusDescription,
    nationality,
    educationLevel,
    occupation,
    maxExpenseFirstTurn,
    maxExpenseSecondTurn,
    totalAssets,
    photoUrl,
    isEligible,
    isReelection,
    birthState,
    birthCity,
    coalitionName,
    roleCode,
    roleName,
    partyNumber,
    partyAcronym,
    partyName,
    assets,
    runningMates,
    files,
  ];
}
