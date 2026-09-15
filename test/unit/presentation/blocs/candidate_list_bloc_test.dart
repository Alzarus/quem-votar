import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';

class MockGetCandidatesListUseCase extends Mock implements GetCandidatesListUseCase {}

class FakeGetCandidatesListParams extends Fake implements GetCandidatesListParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetCandidatesListParams());
  });

  late MockGetCandidatesListUseCase mockUseCase;

  const candidateA = CandidateSummary(
    id: 1,
    ballotNumber: 13,
    ballotName: 'Lula',
    fullName: 'Luiz Inacio Lula da Silva',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'Brasil da Esperanca',
    photoUrl: 'https://example.com/lula.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 7423725.78,
  );

  const candidateB = CandidateSummary(
    id: 2,
    ballotNumber: 22,
    ballotName: 'Bolsonaro',
    fullName: 'Jair Messias Bolsonaro',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PL',
    partyName: 'Partido Liberal',
    coalitionName: 'Pelo Bem do Brasil',
    photoUrl: 'https://example.com/bolsonaro.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 2312554.00,
  );

  const candidateC = CandidateSummary(
    id: 3,
    ballotNumber: 12,
    ballotName: 'Ciro Gomes',
    fullName: 'Ciro Ferreira Gomes',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PDT',
    partyName: 'Partido Democratico Trabalhista',
    coalitionName: 'Sem coligacao',
    photoUrl: 'https://example.com/ciro.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 3044139.87,
  );

  const mockCandidates = [candidateA, candidateB, candidateC];

  setUp(() {
    mockUseCase = MockGetCandidatesListUseCase();
  });

  group('CandidateListBloc - Inicializacao e Estado Inicial', () {
    test('estado inicial deve possuir status initial e listas vazias', () {
      final bloc = CandidateListBloc(getCandidatesListUseCase: mockUseCase);
      expect(bloc.state.status, equals(CandidateListStatus.initial));
      expect(bloc.state.allCandidates, isEmpty);
      expect(bloc.state.filteredCandidates, isEmpty);
      expect(bloc.state.searchQuery, isEmpty);
      expect(bloc.state.selectedParty, isNull);
      expect(bloc.state.sortOption, equals(CandidateSortOption.alphabetical));
      expect(bloc.state.isRefreshing, isFalse);
      expect(bloc.state.failure, isNull);
      bloc.close();
    });

    test('metodos de conveniencia do CandidateListState devem refletir dados', () {
      const state = CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: [candidateA],
        searchQuery: 'Lula',
        selectedParties: {'PT'},
        sortOption: CandidateSortOption.alphabetical,
      );

      expect(state.totalCount, equals(3));
      expect(state.filteredCount, equals(1));
      expect(state.hasActiveFilters, isTrue);
      expect(state.hasModalFilters, isTrue);
      expect(state.modalFiltersCount, equals(1));
      expect(state.activeFiltersCount, equals(2));
      expect(state.selectedParty, equals('PT'));
      expect(state.hasNoResults, isFalse);
      expect(state.availableParties, equals(['PDT', 'PL', 'PT']));
    });
  });

  group('CandidateListBloc - Carga e Falha', () {
    blocTest<CandidateListBloc, CandidateListState>(
      'deve emitir [loading, success] com candidatos ordenados alfabeticamente',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(mockCandidates));
        return CandidateListBloc(getCandidatesListUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const CandidateListLoadStarted(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          roleCode: 1,
        ),
      ),
      expect: () => [
        isA<CandidateListState>().having((s) => s.status, 'status', CandidateListStatus.loading),
        isA<CandidateListState>()
            .having((s) => s.status, 'status', CandidateListStatus.success)
            .having((s) => s.allCandidates.length, 'allCandidates', 3)
            .having(
              (s) => s.filteredCandidates.map((c) => c.ballotName).toList(),
              'filteredCandidates ordenados (Bolsonaro, Ciro Gomes, Lula)',
              ['Bolsonaro', 'Ciro Gomes', 'Lula'],
            )
            .having((s) => s.activeYear, 'year', 2026)
            .having((s) => s.activeUfOrMun, 'uf', 'BR'),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve emitir [loading, failure] quando o caso de uso retornar erro',
      build: () {
        when(() => mockUseCase.execute(any())).thenAnswer(
          (_) async => const Result.failure(
            ServerFailure(message: 'Indisponibilidade temporaria', operationalContext: 'test'),
          ),
        );
        return CandidateListBloc(getCandidatesListUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const CandidateListLoadStarted(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 2040602026,
          roleCode: 1,
        ),
      ),
      expect: () => [
        isA<CandidateListState>().having((s) => s.status, 'status', CandidateListStatus.loading),
        isA<CandidateListState>()
            .having((s) => s.status, 'status', CandidateListStatus.failure)
            .having((s) => s.failure, 'failure', isA<ServerFailure>()),
      ],
    );
  });

  group('CandidateListBloc - Recarga e Atualizacao em Segundo Plano', () {
    blocTest<CandidateListBloc, CandidateListState>(
      'deve emitir isRefreshing true quando forceRefresh for verdadeiro com dados preexistentes',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(mockCandidates));
        return CandidateListBloc(getCandidatesListUseCase: mockUseCase);
      },
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
        activeYear: 2026,
        activeUfOrMun: 'BR',
        activeElectionId: 2040602026,
        activeRoleCode: 1,
      ),
      act: (bloc) => bloc.add(const CandidateListRefreshRequested()),
      expect: () => [
        isA<CandidateListState>().having((s) => s.isRefreshing, 'isRefreshing', isTrue),
        isA<CandidateListState>()
            .having((s) => s.isRefreshing, 'isRefreshing', isFalse)
            .having((s) => s.status, 'status', CandidateListStatus.success),
      ],
    );
  });

  group('CandidateListBloc - Busca Textual com Debounce', () {
    blocTest<CandidateListBloc, CandidateListState>(
      'deve filtrar por nome de urna de forma insensivel a acentos e caixa',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListSearchQueryChanged('ciro')),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.searchQuery, 'query', 'ciro')
            .having((s) => s.filteredCount, 'filteredCount', 1)
            .having((s) => s.filteredCandidates.first.ballotName, 'nome', 'Ciro Gomes'),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve filtrar por numero eleitoral',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListSearchQueryChanged('22')),
      wait: const Duration(milliseconds: 350),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.filteredCount, 'filteredCount', 1)
            .having((s) => s.filteredCandidates.first.ballotNumber, 'numero', 22),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve descartar consultas intermediarias durante o periodo de debounce',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) async {
        bloc.add(const CandidateListSearchQueryChanged('b'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const CandidateListSearchQueryChanged('bo'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(const CandidateListSearchQueryChanged('bol'));
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.searchQuery, 'query', 'bol')
            .having((s) => s.filteredCandidates.first.ballotName, 'nome', 'Bolsonaro'),
      ],
    );
  });

  group('CandidateListBloc - Filtragem Partidaria e Ordenacao', () {
    blocTest<CandidateListBloc, CandidateListState>(
      'deve restringir a listagem pela legenda partidaria informada',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListPartyFilterChanged('PT')),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.selectedParty, 'party', 'PT')
            .having((s) => s.filteredCount, 'filteredCount', 1)
            .having((s) => s.filteredCandidates.first.partyAcronym, 'sigla', 'PT'),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve filtrar candidatos por multiplas legendas simultaneas',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListPartiesChanged({'PT', 'PL'})),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.selectedParties, 'parties', {'PT', 'PL'})
            .having((s) => s.filteredCount, 'filteredCount', 2)
            .having(
              (s) => s.filteredCandidates.map((c) => c.partyAcronym).toSet(),
              'siglas filtradas',
              {'PT', 'PL'},
            ),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve alternar inclusao e exclusao de legenda via CandidateListPartyToggled',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) {
        bloc.add(const CandidateListPartyToggled('PT'));
        bloc.add(const CandidateListPartyToggled('PL'));
        bloc.add(const CandidateListPartyToggled('PT')); // remove PT
      },
      expect: () => [
        isA<CandidateListState>().having((s) => s.selectedParties, 'somente PT', {'PT'}),
        isA<CandidateListState>().having((s) => s.selectedParties, 'PT e PL', {'PT', 'PL'}),
        isA<CandidateListState>().having((s) => s.selectedParties, 'somente PL', {'PL'}),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve reordenar candidatos por numero eleitoral crescente',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) =>
          bloc.add(const CandidateListSortOptionChanged(CandidateSortOption.ballotNumber)),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.sortOption, 'sortOption', CandidateSortOption.ballotNumber)
            .having(
              (s) => s.filteredCandidates.map((c) => c.ballotNumber).toList(),
              'numeros ordenados (12, 13, 22)',
              [12, 13, 22],
            ),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve reordenar candidatos por legenda partidaria',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListSortOptionChanged(CandidateSortOption.party)),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.sortOption, 'sortOption', CandidateSortOption.party)
            .having(
              (s) => s.filteredCandidates.map((c) => c.partyAcronym).toList(),
              'partidos ordenados (PDT, PL, PT)',
              ['PDT', 'PL', 'PT'],
            ),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve filtrar candidatos por situacao juridica (eligibleOnly vs subJudiceOnly)',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () {
        const candidateIneligible = CandidateSummary(
          id: 4,
          ballotNumber: 50,
          ballotName: 'Inapto Teste',
          fullName: 'Candidato Inapto Teste',
          roleCode: 1,
          roleDescription: 'Presidente',
          partyAcronym: 'PSOL',
          partyName: 'Partido Teste',
          coalitionName: 'Sem coligacao',
          photoUrl: 'https://example.com/inapto.jpg',
          registrationStatus: RegistrationStatus.ineligible,
          rawStatusDescription: 'Indeferido',
          totalAssetsAmount: 100000.0,
        );
        final list = [...mockCandidates, candidateIneligible];
        return CandidateListState(
          status: CandidateListStatus.success,
          allCandidates: list,
          filteredCandidates: list,
          searchQuery: '',
          sortOption: CandidateSortOption.alphabetical,
        );
      },
      act: (bloc) =>
          bloc.add(const CandidateListStatusFilterChanged(CandidateStatusFilter.eligibleOnly)),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.statusFilter, 'statusFilter', CandidateStatusFilter.eligibleOnly)
            .having((s) => s.filteredCount, 'filteredCount', 3),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve filtrar candidatos por faixa patrimonial',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) =>
          bloc.add(const CandidateListAssetsFilterChanged(CandidateAssetsFilter.above1M)),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.assetsFilter, 'assetsFilter', CandidateAssetsFilter.above1M)
            .having((s) => s.filteredCount, 'filteredCount', 3),
      ],
    );

    blocTest<CandidateListBloc, CandidateListState>(
      'deve redefinir e limpar integralmente todos os filtros aplicados',
      build: () => CandidateListBloc(getCandidatesListUseCase: mockUseCase),
      seed: () => const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: [candidateA],
        searchQuery: 'Lula',
        selectedParties: {'PT'},
        statusFilter: CandidateStatusFilter.eligibleOnly,
        assetsFilter: CandidateAssetsFilter.above1M,
        sortOption: CandidateSortOption.alphabetical,
      ),
      act: (bloc) => bloc.add(const CandidateListFiltersCleared()),
      expect: () => [
        isA<CandidateListState>()
            .having((s) => s.searchQuery, 'searchQuery limpa', '')
            .having((s) => s.selectedParty, 'partido limpo', isNull)
            .having((s) => s.selectedParties, 'partidos limpos', isEmpty)
            .having((s) => s.statusFilter, 'status limpo', CandidateStatusFilter.all)
            .having((s) => s.assetsFilter, 'patrimonio limpo', CandidateAssetsFilter.all)
            .having((s) => s.filteredCount, 'todos retornados', 3),
      ],
    );
  });
}
