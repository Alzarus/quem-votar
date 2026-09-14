import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/repositories/election_repository.dart';

/// Implementacao falsa nomeada de [ElectionRepository] para testes headless.
class FakeElectionRepository implements ElectionRepository {
  Result<List<Election>, Failure>? nextResult;
  int callCount = 0;

  @override
  Future<Result<List<Election>, Failure>> getElections() async {
    callCount++;
    return nextResult ??
        const Result.success([
          Election(
            id: 20322002026,
            year: 2026,
            name: 'Eleição Geral Federal 2026',
            description: '2026',
            type: 'O',
            scope: 'F',
            electionDate: '2026-10-04',
          ),
        ]);
  }
}
