import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/repositories/candidate_repository.dart';

/// Implementacao falsa nomeada de [CandidateRepository] para testes headless.
class FakeCandidateRepository implements CandidateRepository {
  Result<List<CandidateSummary>, Failure>? nextCandidatesResult;
  Result<CandidateDetail, Failure>? nextDetailResult;

  int getCandidatesCallCount = 0;
  int getCandidateDetailCallCount = 0;

  int? lastYear;
  String? lastUfOrMun;
  int? lastElectionId;
  int? lastRoleCode;
  int? lastCandidateId;
  bool? lastForceRefresh;

  @override
  Future<Result<List<CandidateSummary>, Failure>> getCandidates({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int roleCode,
    bool forceRefresh = false,
  }) async {
    getCandidatesCallCount++;
    lastYear = year;
    lastUfOrMun = ufOrMun;
    lastElectionId = electionId;
    lastRoleCode = roleCode;
    lastForceRefresh = forceRefresh;

    return nextCandidatesResult ??
        const Result.success([
          CandidateSummary(
            id: 280001612393,
            ballotNumber: 12,
            ballotName: 'CIRO GOMES',
            fullName: 'CIRO FERREIRA GOMES',
            roleCode: 1,
            roleDescription: 'Presidente',
            partyAcronym: 'PDT',
            partyName: 'Partido Democrático Trabalhista',
            coalitionName: 'PDT',
            photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12.jpg',
            registrationStatus: RegistrationStatus.deferred,
            rawStatusDescription: 'Deferido',
            totalAssetsAmount: 3039761.97,
          ),
        ]);
  }

  @override
  Future<Result<CandidateDetail, Failure>> getCandidateDetail({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int candidateId,
    bool forceRefresh = false,
  }) async {
    getCandidateDetailCallCount++;
    lastYear = year;
    lastUfOrMun = ufOrMun;
    lastElectionId = electionId;
    lastCandidateId = candidateId;
    lastForceRefresh = forceRefresh;

    return nextDetailResult ??
        const Result.success(
          CandidateDetail(
            id: 280001612393,
            ballotNumber: 12,
            ballotName: 'CIRO GOMES',
            fullName: 'CIRO FERREIRA GOMES',
            roleCode: 1,
            roleDescription: 'Presidente',
            partyAcronym: 'PDT',
            partyName: 'Partido Democrático Trabalhista',
            coalitionName: 'PDT',
            photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12.jpg',
            registrationStatus: RegistrationStatus.deferred,
            rawStatusDescription: 'Deferido',
            totalAssetsAmount: 3039761.97,
            birthDate: '1957-11-06',
            gender: 'MASC.',
            colorRace: 'BRANCA',
            maritalStatus: 'Divorciado(a)',
            educationLevel: 'Superior completo',
            occupation: 'Advogado',
            nationality: 'Brasileira nata',
            birthCity: 'PINDAMONHANGABA',
            birthState: 'SP',
            maxCampaignExpenseFirstTurn: 88944030.8,
            assets: [],
            runningMates: [],
          ),
        );
  }
}
