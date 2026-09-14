import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/repositories/election_repository.dart';

/// Caso de uso com responsabilidade exclusiva de recuperar pleitos eleitorais.
///
/// Encapsula a logica de negocio para selecao e disponibilizacao dos pleitos
/// ordinarios registrados na Justica Eleitoral.
class GetElectionsUseCase {
  final ElectionRepository _repository;

  const GetElectionsUseCase(this._repository);

  /// Executa a consulta de pleitos eleitorais ordinarios.
  Future<Result<List<Election>, Failure>> execute() {
    return _repository.getElections();
  }
}
