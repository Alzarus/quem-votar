import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';

import '../fakes/fake_candidate_repository.dart';

void main() {
  group('GetCandidatesListUseCase - Listagem de Candidatos e Validacao Defensiva', () {
    late FakeCandidateRepository fakeRepository;
    late GetCandidatesListUseCase useCase;

    setUp(() {
      fakeRepository = FakeCandidateRepository();
      useCase = GetCandidatesListUseCase(fakeRepository);
    });

    test('deve executar com sucesso normalizando sigla territorial para maiusculo', () async {
      const candidates = [
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
      ];
      fakeRepository.nextCandidatesResult = const Result.success(candidates);

      const params = GetCandidatesListParams(
        year: 2026,
        ufOrMun: ' br ',
        electionId: 20322002026,
        roleCode: 1,
        forceRefresh: true,
      );

      final result = await useCase.execute(params);

      expect(result.isSuccess, isTrue);
      expect(result.successOrNull, equals(candidates));
      expect(fakeRepository.lastYear, equals(2026));
      expect(fakeRepository.lastUfOrMun, equals('BR'));
      expect(fakeRepository.lastElectionId, equals(20322002026));
      expect(fakeRepository.lastRoleCode, equals(1));
      expect(fakeRepository.lastForceRefresh, isTrue);
      expect(fakeRepository.getCandidatesCallCount, equals(1));
    });

    test('deve rejeitar ano eleitoral anterior a 1988 sem acionar repositorio', () async {
      const params = GetCandidatesListParams(
        year: 1987,
        ufOrMun: 'BR',
        electionId: 20322002026,
        roleCode: 1,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidatesCallCount, equals(0));
    });

    test('deve rejeitar abrangencia territorial vazia ou apenas com espacos', () async {
      const params = GetCandidatesListParams(
        year: 2026,
        ufOrMun: '   ',
        electionId: 20322002026,
        roleCode: 1,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidatesCallCount, equals(0));
    });

    test('deve rejeitar identificador da eleicao menor ou igual a zero', () async {
      const params = GetCandidatesListParams(year: 2026, ufOrMun: 'BR', electionId: 0, roleCode: 1);

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidatesCallCount, equals(0));
    });

    test('deve rejeitar codigo de cargo fora do intervalo do TSE (1 a 13)', () async {
      const invalidRoles = [0, 14, -5];

      for (final roleCode in invalidRoles) {
        final params = GetCandidatesListParams(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 20322002026,
          roleCode: roleCode,
        );

        final result = await useCase.execute(params);

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<ParsingFailure>());
      }

      expect(fakeRepository.getCandidatesCallCount, equals(0));
    });

    test('deve propagar falha de rede do repositorio', () async {
      const networkFailure = NetworkFailure(
        message: 'Timeout ao conectar com infraestrutura perimetral.',
        operationalContext: 'FakeCandidateRepository.getCandidates',
      );
      fakeRepository.nextCandidatesResult = const Result.failure(networkFailure);

      const params = GetCandidatesListParams(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 20322002026,
        roleCode: 1,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, equals(networkFailure));
      expect(fakeRepository.getCandidatesCallCount, equals(1));
    });
  });
}
