import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_state.dart';

class MockGetCandidateDetailUseCase extends Mock implements GetCandidateDetailUseCase {}

class FakeGetCandidateDetailParams extends Fake implements GetCandidateDetailParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetCandidateDetailParams());
  });

  late MockGetCandidateDetailUseCase mockUseCase;

  const candidate1 = CandidateSummary(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Candidato Alpha',
    fullName: 'Nome Completo Alpha',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PA',
    partyName: 'Partido Alpha',
    coalitionName: 'Coligacao Alpha',
    photoUrl: 'https://example.com/alpha.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 1000000.0,
  );

  const candidate2 = CandidateSummary(
    id: 102,
    ballotNumber: 22,
    ballotName: 'Candidato Beta',
    fullName: 'Nome Completo Beta',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PB',
    partyName: 'Partido Beta',
    coalitionName: 'Coligacao Beta',
    photoUrl: 'https://example.com/beta.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 2000000.0,
  );

  const candidate3 = CandidateSummary(
    id: 103,
    ballotNumber: 33,
    ballotName: 'Candidato Gama',
    fullName: 'Nome Completo Gama',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PG',
    partyName: 'Partido Gama',
    coalitionName: 'Coligacao Gama',
    photoUrl: 'https://example.com/gama.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 500000.0,
  );

  const candidate4 = CandidateSummary(
    id: 104,
    ballotNumber: 44,
    ballotName: 'Candidato Delta',
    fullName: 'Nome Completo Delta',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PD',
    partyName: 'Partido Delta',
    coalitionName: 'Coligacao Delta',
    photoUrl: 'https://example.com/delta.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 800000.0,
  );

  const candidateDifferentRole = CandidateSummary(
    id: 105,
    ballotNumber: 555,
    ballotName: 'Candidato Senador',
    fullName: 'Nome Completo Senador',
    roleCode: 5,
    roleDescription: 'Senador',
    partyAcronym: 'PS',
    partyName: 'Partido Senador',
    coalitionName: 'Coligacao Senador',
    photoUrl: 'https://example.com/senador.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 300000.0,
  );

  const detailAlpha = CandidateDetail(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Candidato Alpha',
    fullName: 'Nome Completo Alpha',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PA',
    partyName: 'Partido Alpha',
    coalitionName: 'Coligacao Alpha',
    photoUrl: 'https://example.com/alpha.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 1000000.0,
    birthDate: '1970-01-01',
    gender: 'MASCULINO',
    colorRace: 'BRANCA',
    maritalStatus: 'CASADO(A)',
    educationLevel: 'SUPERIOR COMPLETO',
    occupation: 'ADVOGADO',
    nationality: 'BRASILEIRA',
    birthCity: 'BRASILIA',
    birthState: 'DF',
    maxCampaignExpenseFirstTurn: 50000000.0,
    maxCampaignExpenseSecondTurn: 25000000.0,
    assets: [],
    runningMates: [],
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta.pdf',
  );

  setUp(() {
    mockUseCase = MockGetCandidateDetailUseCase();
  });

  group('CandidateComparisonBloc - Gerenciamento de Selecao e Integridade', () {
    test('estado inicial deve ser vazio e sem notificacoes', () {
      final bloc = CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase);
      expect(bloc.state.selectedCandidates, isEmpty);
      expect(bloc.state.candidateDetails, isEmpty);
      expect(bloc.state.canCompare, isFalse);
      expect(bloc.state.isFull, isFalse);
      expect(bloc.state.count, 0);
    });

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve adicionar candidato a selecao ao disparar Toggle',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      act: (bloc) => bloc.add(const CandidateComparisonCandidateToggled(candidate1)),
      expect: () => [
        const CandidateComparisonState(selectedCandidates: [candidate1]),
      ],
    );

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve remover candidato da selecao ao disparar Toggle para candidato ja selecionado',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateComparisonState(selectedCandidates: [candidate1]),
      act: (bloc) => bloc.add(const CandidateComparisonCandidateToggled(candidate1)),
      expect: () => [const CandidateComparisonState(selectedCandidates: [])],
    );

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve remover candidato por id via CandidateComparisonCandidateRemoved',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateComparisonState(selectedCandidates: [candidate1, candidate2]),
      act: (bloc) => bloc.add(const CandidateComparisonCandidateRemoved(101)),
      expect: () => [
        const CandidateComparisonState(selectedCandidates: [candidate2]),
      ],
    );

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve limpar toda a selecao via CandidateComparisonSelectionCleared',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateComparisonState(selectedCandidates: [candidate1, candidate2]),
      act: (bloc) => bloc.add(const CandidateComparisonSelectionCleared()),
      expect: () => [const CandidateComparisonState()],
    );

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve impedir adicao alem do limite maximo de 4 candidatos e emitir notificacao',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateComparisonState(
        selectedCandidates: [candidate1, candidate2, candidate3, candidate4],
      ),
      act: (bloc) => bloc.add(
        const CandidateComparisonCandidateToggled(
          CandidateSummary(
            id: 106,
            ballotNumber: 66,
            ballotName: 'Candidato Extra',
            fullName: 'Nome Completo Extra',
            roleCode: 1,
            roleDescription: 'Presidente',
            partyAcronym: 'PE',
            partyName: 'Partido Extra',
            coalitionName: 'Coligacao Extra',
            photoUrl: '',
            registrationStatus: RegistrationStatus.deferred,
            rawStatusDescription: 'Deferido',
            totalAssetsAmount: 0.0,
          ),
        ),
      ),
      expect: () => [
        const CandidateComparisonState(
          selectedCandidates: [candidate1, candidate2, candidate3, candidate4],
          notificationMessage: 'Limite de 4 candidaturas atingido para comparacao.',
        ),
      ],
    );

    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve impedir adicao de candidato com cargo diferente e emitir aviso educativo',
      build: () => CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateComparisonState(selectedCandidates: [candidate1]),
      act: (bloc) => bloc.add(const CandidateComparisonCandidateToggled(candidateDifferentRole)),
      expect: () => [
        const CandidateComparisonState(
          selectedCandidates: [candidate1],
          notificationMessage:
              'Apenas candidaturas concorrentes ao mesmo cargo podem ser comparadas.',
        ),
      ],
    );
  });

  group('CandidateComparisonBloc - Carga Concorrente de Detalhes', () {
    blocTest<CandidateComparisonBloc, CandidateComparisonState>(
      'deve carregar detalhes das candidaturas selecionadas com sucesso',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(detailAlpha));
        return CandidateComparisonBloc(getCandidateDetailUseCase: mockUseCase);
      },
      seed: () => const CandidateComparisonState(selectedCandidates: [candidate1]),
      act: (bloc) => bloc.add(
        const CandidateComparisonDetailsLoadStarted(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 20322002026,
        ),
      ),
      expect: () => [
        const CandidateComparisonState(
          selectedCandidates: [candidate1],
          status: CandidateComparisonStatus.loading,
        ),
        const CandidateComparisonState(
          selectedCandidates: [candidate1],
          candidateDetails: {101: detailAlpha},
          status: CandidateComparisonStatus.success,
        ),
      ],
      verify: (_) {
        verify(() => mockUseCase.execute(any())).called(1);
      },
    );
  });
}
