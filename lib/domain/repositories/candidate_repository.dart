import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';

/// Contrato abstrato para consulta e cache reativo de candidaturas oficiais.
abstract interface class CandidateRepository {
  /// Consulta a listagem de candidaturas sintetizadas para um determinado cargo e regiao.
  Future<Result<List<CandidateSummary>, Failure>> getCandidates({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int roleCode,
    bool forceRefresh = false,
  });

  /// Consulta a ficha cadastral consolidada contendo bens, composicao de chapa e despesas.
  Future<Result<CandidateDetail, Failure>> getCandidateDetail({
    required int year,
    required String ufOrMun,
    required int electionId,
    required int candidateId,
    bool forceRefresh = false,
  });
}
