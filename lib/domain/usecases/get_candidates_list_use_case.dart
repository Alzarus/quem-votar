import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/repositories/candidate_repository.dart';

/// Parametros de consulta para listagem de candidaturas oficiais.
class GetCandidatesListParams extends Equatable {
  final int year;
  final String ufOrMun;
  final int electionId;
  final int roleCode;
  final bool forceRefresh;

  const GetCandidatesListParams({
    required this.year,
    required this.ufOrMun,
    required this.electionId,
    required this.roleCode,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [year, ufOrMun, electionId, roleCode, forceRefresh];
}

/// Caso de uso com responsabilidade exclusiva de recuperar a lista de candidatos.
class GetCandidatesListUseCase {
  final CandidateRepository _repository;

  const GetCandidatesListUseCase(this._repository);

  /// Executa a busca de candidaturas aplicando validacao defensiva nos parametros.
  Future<Result<List<CandidateSummary>, Failure>> execute(GetCandidatesListParams params) async {
    final validationFailure = _validateParams(params);
    if (validationFailure != null) {
      return Result.failure(validationFailure);
    }

    return _repository.getCandidates(
      year: params.year,
      ufOrMun: params.ufOrMun.trim().toUpperCase(),
      electionId: params.electionId,
      roleCode: params.roleCode,
      forceRefresh: params.forceRefresh,
    );
  }

  Failure? _validateParams(GetCandidatesListParams params) {
    if (params.year < 1988) {
      return ParsingFailure(
        message: 'Ano eleitoral invalido. Deve ser igual ou superior a 1988.',
        operationalContext: 'GetCandidatesListUseCase._validateParams',
        receivedValue: params.year,
        expectedFormat: 'Ano >= 1988',
      );
    }
    if (params.ufOrMun.trim().isEmpty) {
      return ParsingFailure(
        message: 'Identificador territorial (UF ou Municipio) nao pode ser vazio.',
        operationalContext: 'GetCandidatesListUseCase._validateParams',
        receivedValue: params.ufOrMun,
        expectedFormat: 'Sigla UF ou codigo de municipio TSE',
      );
    }
    return _validateNumericIds(params);
  }

  Failure? _validateNumericIds(GetCandidatesListParams params) {
    if (params.electionId <= 0) {
      return ParsingFailure(
        message: 'Identificador da eleicao (idEleicao) deve ser positivo.',
        operationalContext: 'GetCandidatesListUseCase._validateNumericIds',
        receivedValue: params.electionId,
        expectedFormat: 'int64 positivo',
      );
    }
    if (params.roleCode < 1 || params.roleCode > 13) {
      return ParsingFailure(
        message: 'Codigo de cargo fora do intervalo oficial do TSE (1 a 13).',
        operationalContext: 'GetCandidatesListUseCase._validateNumericIds',
        receivedValue: params.roleCode,
        expectedFormat: 'Inteiro entre 1 e 13',
      );
    }
    return null;
  }
}
