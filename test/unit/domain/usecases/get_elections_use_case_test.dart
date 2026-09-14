import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';

import '../fakes/fake_election_repository.dart';

void main() {
  group('GetElectionsUseCase - Obtencao de Pleitos Eleitorais Oficiais', () {
    late FakeElectionRepository fakeRepository;
    late GetElectionsUseCase useCase;

    setUp(() {
      fakeRepository = FakeElectionRepository();
      useCase = GetElectionsUseCase(fakeRepository);
    });

    test('deve retornar lista de eleicoes encapsulada em Result.success', () async {
      const expectedElections = [
        Election(
          id: 20322002026,
          year: 2026,
          name: 'Eleição Geral Federal 2026',
          description: '2026',
          type: 'O',
          scope: 'F',
          electionDate: '2026-10-04',
        ),
      ];
      fakeRepository.nextResult = const Result.success(expectedElections);

      final result = await useCase.execute();

      expect(result.isSuccess, isTrue);
      expect(result.successOrNull, equals(expectedElections));
      expect(fakeRepository.callCount, equals(1));
    });

    test('deve propagar falha do repositorio encapsulada em Result.failure', () async {
      const serverFailure = ServerFailure(
        message: 'Servidor do TSE temporariamente indisponivel.',
        operationalContext: 'FakeElectionRepository.getElections',
        statusCode: 503,
      );
      fakeRepository.nextResult = const Result.failure(serverFailure);

      final result = await useCase.execute();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, equals(serverFailure));
      expect(fakeRepository.callCount, equals(1));
    });
  });
}
