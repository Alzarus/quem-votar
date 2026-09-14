import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';

import '../fakes/fake_candidate_repository.dart';

void main() {
  group('GetCandidateDetailUseCase - Ficha Consolidada e Validacao Defensiva', () {
    late FakeCandidateRepository fakeRepository;
    late GetCandidateDetailUseCase useCase;

    setUp(() {
      fakeRepository = FakeCandidateRepository();
      useCase = GetCandidateDetailUseCase(fakeRepository);
    });

    test('deve executar com sucesso normalizando sigla territorial para maiusculo', () async {
      const detail = CandidateDetail(
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
      );
      fakeRepository.nextDetailResult = const Result.success(detail);

      const params = GetCandidateDetailParams(
        year: 2026,
        ufOrMun: ' br ',
        electionId: 20322002026,
        candidateId: 280001612393,
        forceRefresh: true,
      );

      final result = await useCase.execute(params);

      expect(result.isSuccess, isTrue);
      expect(result.successOrNull, equals(detail));
      expect(fakeRepository.lastYear, equals(2026));
      expect(fakeRepository.lastUfOrMun, equals('BR'));
      expect(fakeRepository.lastElectionId, equals(20322002026));
      expect(fakeRepository.lastCandidateId, equals(280001612393));
      expect(fakeRepository.lastForceRefresh, isTrue);
      expect(fakeRepository.getCandidateDetailCallCount, equals(1));
    });

    test('deve rejeitar ano eleitoral anterior a 1988 sem acionar repositorio', () async {
      const params = GetCandidateDetailParams(
        year: 1985,
        ufOrMun: 'BR',
        electionId: 20322002026,
        candidateId: 280001612393,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidateDetailCallCount, equals(0));
    });

    test('deve rejeitar identificador territorial vazio sem acionar repositorio', () async {
      const params = GetCandidateDetailParams(
        year: 2026,
        ufOrMun: '',
        electionId: 20322002026,
        candidateId: 280001612393,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidateDetailCallCount, equals(0));
    });

    test('deve rejeitar identificador de eleicao menor ou igual a zero', () async {
      const params = GetCandidateDetailParams(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 0,
        candidateId: 280001612393,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidateDetailCallCount, equals(0));
    });

    test('deve rejeitar identificador do candidato menor ou igual a zero', () async {
      const params = GetCandidateDetailParams(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 20322002026,
        candidateId: -10,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ParsingFailure>());
      expect(fakeRepository.getCandidateDetailCallCount, equals(0));
    });

    test('deve propagar falha de servidor retornada pelo repositorio', () async {
      const serverFailure = ServerFailure(
        message: 'Candidato nao localizado na base oficial.',
        operationalContext: 'FakeCandidateRepository.getCandidateDetail',
        statusCode: 404,
      );
      fakeRepository.nextDetailResult = const Result.failure(serverFailure);

      const params = GetCandidateDetailParams(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 20322002026,
        candidateId: 280001612393,
      );

      final result = await useCase.execute(params);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, equals(serverFailure));
      expect(fakeRepository.getCandidateDetailCallCount, equals(1));
    });
  });
}
