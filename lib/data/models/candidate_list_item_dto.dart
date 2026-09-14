import 'package:equatable/equatable.dart';

/// DTO representativo da projecao sintetica do candidato na listagem da API do TSE.
///
/// Mapeia cada elemento do array `candidatos[]` retornado pela rota
/// `/candidatura/listar/{ano}/{siglaUf}/{idEleicao}/{codigoCargo}/candidatos`.
class CandidateListItemDto extends Equatable {
  final int id;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final String rawStatusDescription;
  final bool isEligible;
  final bool isReelection;
  final String coalitionName;
  final int roleCode;
  final String roleName;
  final int partyNumber;
  final String partyAcronym;
  final String? partyName;
  final double? totalAssets;
  final String? photoUrl;

  const CandidateListItemDto({
    required this.id,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.rawStatusDescription,
    required this.isEligible,
    required this.isReelection,
    required this.coalitionName,
    required this.roleCode,
    required this.roleName,
    required this.partyNumber,
    required this.partyAcronym,
    this.partyName,
    this.totalAssets,
    this.photoUrl,
  });

  /// Instancia DTO com conversao defensiva de nulos para campos ausentes no resumo.
  factory CandidateListItemDto.fromJson(Map<String, dynamic> json) {
    final cargoMap = json['cargo'] as Map<String, dynamic>? ?? {};
    final partidoMap = json['partido'] as Map<String, dynamic>? ?? {};

    return CandidateListItemDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ballotNumber: (json['numero'] as num?)?.toInt() ?? 0,
      ballotName: json['nomeUrna'] as String? ?? '',
      fullName: json['nomeCompleto'] as String? ?? '',
      rawStatusDescription: json['descricaoSituacao'] as String? ?? '',
      isEligible: json['candidatoApto'] as bool? ?? true,
      isReelection: json['st_REELEICAO'] as bool? ?? false,
      coalitionName: json['nomeColigacao'] as String? ?? '',
      roleCode: (cargoMap['codigo'] as num?)?.toInt() ?? 0,
      roleName: cargoMap['nome'] as String? ?? '',
      partyNumber: (partidoMap['numero'] as num?)?.toInt() ?? 0,
      partyAcronym: partidoMap['sigla'] as String? ?? '',
      partyName: partidoMap['nome'] as String?,
      totalAssets: (json['totalDeBens'] as num?)?.toDouble(),
      photoUrl: json['fotoUrl'] as String?,
    );
  }

  /// Converte a instancia em mapa serializavel.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': ballotNumber,
      'nomeUrna': ballotName,
      'nomeCompleto': fullName,
      'descricaoSituacao': rawStatusDescription,
      'candidatoApto': isEligible,
      'st_REELEICAO': isReelection,
      'nomeColigacao': coalitionName,
      'cargo': {'codigo': roleCode, 'nome': roleName},
      'partido': {'numero': partyNumber, 'sigla': partyAcronym, 'nome': partyName},
      'totalDeBens': totalAssets,
      'fotoUrl': photoUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    ballotNumber,
    ballotName,
    fullName,
    rawStatusDescription,
    isEligible,
    isReelection,
    coalitionName,
    roleCode,
    roleName,
    partyNumber,
    partyAcronym,
    partyName,
    totalAssets,
    photoUrl,
  ];
}
