import 'package:equatable/equatable.dart';

/// Integrante da chapa majoritaria (Vice-Presidente, Vice-Governador,
/// Vice-Prefeito ou Suplentes de Senador) vinculado a candidatura titular.
class RunningMate extends Equatable {
  final int id;
  final int? parentCandidateId;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final String partyAcronym;
  final String partyName;
  final String roleDescription;
  final String photoUrl;
  final bool isEligible;

  const RunningMate({
    required this.id,
    this.parentCandidateId,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.partyAcronym,
    required this.partyName,
    required this.roleDescription,
    required this.photoUrl,
    required this.isEligible,
  });

  @override
  List<Object?> get props => [
    id,
    parentCandidateId,
    ballotNumber,
    ballotName,
    fullName,
    partyAcronym,
    partyName,
    roleDescription,
    photoUrl,
    isEligible,
  ];
}
