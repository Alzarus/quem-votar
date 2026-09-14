import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/election.dart';

/// Contrato abstrato para obtencao e sincronizacao de pleitos eleitorais.
abstract interface class ElectionRepository {
  /// Recupera a lista oficial de pleitos eleitorais ordinarios registrados no TSE.
  Future<Result<List<Election>, Failure>> getElections();
}
