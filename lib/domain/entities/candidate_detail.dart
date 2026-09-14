import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';

/// Ficha individual consolidada da candidatura oficial.
///
/// Expande o resumo da candidatura com dados civis completos, tetos de gastos
/// de campanha autorizados pelo TSE, discriminacao pormenorizada de bens patrimoniais,
/// composicao da chapa majoritaria e hiperlink para proposta de governo.
class CandidateDetail extends CandidateSummary {
  final String birthDate;
  final String gender;
  final String colorRace;
  final String maritalStatus;
  final String educationLevel;
  final String occupation;
  final String nationality;
  final String birthCity;
  final String birthState;
  final double maxCampaignExpenseFirstTurn;
  final double? maxCampaignExpenseSecondTurn;
  final List<CandidateAsset> assets;
  final List<RunningMate> runningMates;
  final String? proposalDocumentUrl;

  const CandidateDetail({
    required super.id,
    required super.ballotNumber,
    required super.ballotName,
    required super.fullName,
    required super.roleCode,
    required super.roleDescription,
    required super.partyAcronym,
    required super.partyName,
    required super.coalitionName,
    required super.photoUrl,
    required super.registrationStatus,
    required super.rawStatusDescription,
    required super.totalAssetsAmount,
    super.parentCandidateId,
    required this.birthDate,
    required this.gender,
    required this.colorRace,
    required this.maritalStatus,
    required this.educationLevel,
    required this.occupation,
    required this.nationality,
    required this.birthCity,
    required this.birthState,
    required this.maxCampaignExpenseFirstTurn,
    this.maxCampaignExpenseSecondTurn,
    required this.assets,
    required this.runningMates,
    this.proposalDocumentUrl,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    birthDate,
    gender,
    colorRace,
    maritalStatus,
    educationLevel,
    occupation,
    nationality,
    birthCity,
    birthState,
    maxCampaignExpenseFirstTurn,
    maxCampaignExpenseSecondTurn,
    assets,
    runningMates,
    proposalDocumentUrl,
  ];
}
