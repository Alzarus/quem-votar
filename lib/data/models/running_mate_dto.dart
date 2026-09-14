import 'package:equatable/equatable.dart';

/// DTO representativo de integrante de chapa majoritaria (vice ou suplente).
///
/// Mapeia cada elemento do array `vices[]` da ficha detalhada de candidatura.
class RunningMateDto extends Equatable {
  final int candidateId;
  final int? parentCandidateId;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final String roleDescription;
  final String partyAcronym;
  final String partyName;
  final String photoUrl;
  final bool isEligible;

  const RunningMateDto({
    required this.candidateId,
    this.parentCandidateId,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.roleDescription,
    required this.partyAcronym,
    required this.partyName,
    required this.photoUrl,
    required this.isEligible,
  });

  /// Instancia DTO com conversao defensiva para identificadores e numeros de urna.
  factory RunningMateDto.fromJson(Map<String, dynamic> json) {
    return RunningMateDto(
      candidateId: (json['sq_CANDIDATO'] as num?)?.toInt() ?? 0,
      parentCandidateId: (json['sq_CANDIDATO_SUPERIOR'] as num?)?.toInt(),
      ballotNumber: _parseBallotNumber(json['nr_CANDIDATO']),
      ballotName: json['nm_URNA'] as String? ?? '',
      fullName: json['nm_CANDIDATO'] as String? ?? '',
      roleDescription: json['ds_CARGO'] as String? ?? '',
      partyAcronym: json['sg_PARTIDO'] as String? ?? '',
      partyName: json['nm_PARTIDO'] as String? ?? '',
      photoUrl: json['urlFoto'] as String? ?? '',
      isEligible: json['candidatoApto'] as bool? ?? true,
    );
  }

  /// Converte a instancia em mapa serializavel.
  Map<String, dynamic> toJson() {
    return {
      'sq_CANDIDATO': candidateId,
      'sq_CANDIDATO_SUPERIOR': parentCandidateId,
      'nr_CANDIDATO': ballotNumber.toString(),
      'nm_URNA': ballotName,
      'nm_CANDIDATO': fullName,
      'ds_CARGO': roleDescription,
      'sg_PARTIDO': partyAcronym,
      'nm_PARTIDO': partyName,
      'urlFoto': photoUrl,
      'candidatoApto': isEligible,
    };
  }

  /// Converte valor de numero de urna suportando tipos inteiros ou strings.
  static int _parseBallotNumber(Object? raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim()) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
    candidateId,
    parentCandidateId,
    ballotNumber,
    ballotName,
    fullName,
    roleDescription,
    partyAcronym,
    partyName,
    photoUrl,
    isEligible,
  ];
}
