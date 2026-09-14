import 'package:equatable/equatable.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';

/// Representacao sintetica de uma candidatura oficial.
///
/// Utilizada primordialmente em componentes de listagem, cartoes e buscas,
/// contendo informacoes essenciais de urna, partido e situacao juridica.
class CandidateSummary extends Equatable {
  final int id;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final int roleCode;
  final String roleDescription;
  final String partyAcronym;
  final String partyName;
  final String coalitionName;
  final String photoUrl;
  final RegistrationStatus registrationStatus;
  final String rawStatusDescription;
  final double? totalAssetsAmount;
  final int? parentCandidateId;

  const CandidateSummary({
    required this.id,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.roleCode,
    required this.roleDescription,
    required this.partyAcronym,
    required this.partyName,
    required this.coalitionName,
    required this.photoUrl,
    required this.registrationStatus,
    required this.rawStatusDescription,
    this.totalAssetsAmount,
    this.parentCandidateId,
  });

  @override
  List<Object?> get props => [
    id,
    ballotNumber,
    ballotName,
    fullName,
    roleCode,
    roleDescription,
    partyAcronym,
    partyName,
    coalitionName,
    photoUrl,
    registrationStatus,
    rawStatusDescription,
    totalAssetsAmount,
    parentCandidateId,
  ];
}
