import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/repositories/candidate_repository.dart';

/// Parametros de consulta para obtencao da ficha detalhada do candidato.
class GetCandidateDetailParams extends Equatable {
  final int year;
  final String ufOrMun;
  final int electionId;
  final int candidateId;
  final bool forceRefresh;

  const GetCandidateDetailParams({
    required this.year,
    required this.ufOrMun,
    required this.electionId,
    required this.candidateId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [year, ufOrMun, electionId, candidateId, forceRefresh];
}

/// Caso de uso com responsabilidade exclusiva de recuperar a ficha detalhada.
class GetCandidateDetailUseCase {
  final CandidateRepository _repository;

  const GetCandidateDetailUseCase(this._repository);

  /// Executa a recuperacao da ficha detalhada com validacao defensiva.
  Future<Result<CandidateDetail, Failure>> execute(GetCandidateDetailParams params) async {
    final validationFailure = _validateParams(params);
    if (validationFailure != null) {
      return Result.failure(validationFailure);
    }

    return _repository.getCandidateDetail(
      year: params.year,
      ufOrMun: params.ufOrMun.trim().toUpperCase(),
      electionId: params.electionId,
      candidateId: params.candidateId,
      forceRefresh: params.forceRefresh,
    );
  }

  Failure? _validateParams(GetCandidateDetailParams params) {
    if (params.year < 1988) {
      return ParsingFailure(
        message: 'Ano eleitoral invalido. Deve ser igual ou superior a 1988.',
        operationalContext: 'GetCandidateDetailUseCase._validateParams',
        receivedValue: params.year,
        expectedFormat: 'Ano >= 1988',
      );
    }
    if (params.ufOrMun.trim().isEmpty) {
      return ParsingFailure(
        message: 'Identificador territorial (UF ou Municipio) nao pode ser vazio.',
        operationalContext: 'GetCandidateDetailUseCase._validateParams',
        receivedValue: params.ufOrMun,
        expectedFormat: 'Sigla UF ou codigo de municipio TSE',
      );
    }
    return _validateIdentifiers(params);
  }

  Failure? _validateIdentifiers(GetCandidateDetailParams params) {
    if (params.electionId <= 0) {
      return ParsingFailure(
        message: 'Identificador da eleicao (idEleicao) deve ser positivo.',
        operationalContext: 'GetCandidateDetailUseCase._validateIdentifiers',
        receivedValue: params.electionId,
        expectedFormat: 'int64 positivo',
      );
    }
    if (params.candidateId <= 0) {
      return ParsingFailure(
        message: 'Sequencial do candidato (idCandidato) deve ser positivo.',
        operationalContext: 'GetCandidateDetailUseCase._validateIdentifiers',
        receivedValue: params.candidateId,
        expectedFormat: 'int64 positivo',
      );
    }
    return null;
  }
}
