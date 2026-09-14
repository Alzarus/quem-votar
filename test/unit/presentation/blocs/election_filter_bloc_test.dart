import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_state.dart';

class MockGetElectionsUseCase extends Mock implements GetElectionsUseCase {}

void main() {
  late MockGetElectionsUseCase mockGetElectionsUseCase;

  const election2026 = Election(
    id: 2040602026,
    year: 2026,
    name: 'Eleição Geral Federal 2026',
    description: 'Eleições Gerais Ordinárias de 2026',
    type: 'ORDINARIA',
    scope: 'FEDERAL',
    electionDate: '2026-10-04',
  );

  const election2022 = Election(
    id: 2040602022,
    year: 2022,
    name: 'Eleição Geral Federal 2022',
    description: 'Eleições Gerais Ordinárias de 2022',
    type: 'ORDINARIA',
    scope: 'FEDERAL',
    electionDate: '2022-10-02',
  );

  setUp(() {
    mockGetElectionsUseCase = MockGetElectionsUseCase();
  });

  group('ElectionFilterBloc - Inicializacao e Transicoes de Estado', () {
    test('estado inicial deve possuir status initial e UFs completas', () {
      final bloc = ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase);
      expect(bloc.state.status, equals(ElectionFilterStatus.initial));
      expect(bloc.state.availableUfs.length, equals(28));
      expect(bloc.state.selectedElection, isNull);
      expect(bloc.state.selectedRole, isNull);
    });

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve emitir [loading, success] com pleito padrao de 2026, BR e Presidente',
      build: () {
        when(
          () => mockGetElectionsUseCase.execute(),
        ).thenAnswer((_) async => const Result.success([election2022, election2026]));
        return ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase);
      },
      act: (bloc) => bloc.add(const ElectionFilterStarted()),
      expect: () => [
        isA<ElectionFilterState>().having((s) => s.status, 'status', ElectionFilterStatus.loading),
        isA<ElectionFilterState>()
            .having((s) => s.status, 'status', ElectionFilterStatus.success)
            .having((s) => s.selectedElection, 'selectedElection', election2026)
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.br)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.president)
            .having((s) => s.availableRoles, 'availableRoles', [ElectionRole.president]),
      ],
      verify: (_) {
        verify(() => mockGetElectionsUseCase.execute()).called(1);
      },
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve selecionar o primeiro pleito disponivel caso 2026 nao esteja presente',
      build: () {
        when(
          () => mockGetElectionsUseCase.execute(),
        ).thenAnswer((_) async => const Result.success([election2022]));
        return ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase);
      },
      act: (bloc) => bloc.add(const ElectionFilterStarted()),
      expect: () => [
        isA<ElectionFilterState>().having((s) => s.status, 'status', ElectionFilterStatus.loading),
        isA<ElectionFilterState>()
            .having((s) => s.status, 'status', ElectionFilterStatus.success)
            .having((s) => s.selectedElection, 'selectedElection', election2022),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve emitir [loading, failure] quando o caso de uso retornar falha',
      build: () {
        when(() => mockGetElectionsUseCase.execute()).thenAnswer(
          (_) async => const Result.failure(
            ServerFailure(
              message: 'Erro HTTP 500 do TSE',
              operationalContext: 'GetElectionsUseCase.execute',
            ),
          ),
        );
        return ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase);
      },
      act: (bloc) => bloc.add(const ElectionFilterStarted()),
      expect: () => [
        isA<ElectionFilterState>().having((s) => s.status, 'status', ElectionFilterStatus.loading),
        isA<ElectionFilterState>()
            .having((s) => s.status, 'status', ElectionFilterStatus.failure)
            .having((s) => s.failure, 'failure', isA<ServerFailure>()),
      ],
    );
  });

  group('ElectionFilterBloc - Alteracao de Pleito, UF e Cargo', () {
    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve alterar o pleito selecionado preservando UF e Cargo vigentes',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        elections: [election2026, election2022],
        selectedElection: election2026,
        selectedUf: FederativeUnit.br,
        selectedRole: ElectionRole.president,
        availableRoles: [ElectionRole.president],
      ),
      act: (bloc) => bloc.add(const ElectionFilterElectionChanged(election2022)),
      expect: () => [
        isA<ElectionFilterState>()
            .having((s) => s.selectedElection, 'selectedElection', election2022)
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.br)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.president),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve atualizar cargos e definir Governador ao transitar de BR para Estado (SP)',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.br,
        selectedRole: ElectionRole.president,
        availableRoles: [ElectionRole.president],
      ),
      act: (bloc) => bloc.add(const ElectionFilterUfChanged(FederativeUnit.sp)),
      expect: () => [
        isA<ElectionFilterState>()
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.sp)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.governor)
            .having((s) => s.availableRoles, 'availableRoles', [
              ElectionRole.governor,
              ElectionRole.senator,
              ElectionRole.federalDeputy,
              ElectionRole.stateDeputy,
            ]),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve incluir Deputado Distrital e excluir Estadual ao selecionar DF',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.sp,
        selectedRole: ElectionRole.stateDeputy,
        availableRoles: [
          ElectionRole.governor,
          ElectionRole.senator,
          ElectionRole.federalDeputy,
          ElectionRole.stateDeputy,
        ],
      ),
      act: (bloc) => bloc.add(const ElectionFilterUfChanged(FederativeUnit.df)),
      expect: () => [
        isA<ElectionFilterState>()
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.df)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.governor)
            .having((s) => s.availableRoles, 'availableRoles', [
              ElectionRole.governor,
              ElectionRole.senator,
              ElectionRole.federalDeputy,
              ElectionRole.districtDeputy,
            ]),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve preservar o cargo ativo se compativel com a nova UF (Senador em SP -> DF)',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.sp,
        selectedRole: ElectionRole.senator,
        availableRoles: [
          ElectionRole.governor,
          ElectionRole.senator,
          ElectionRole.federalDeputy,
          ElectionRole.stateDeputy,
        ],
      ),
      act: (bloc) => bloc.add(const ElectionFilterUfChanged(FederativeUnit.df)),
      expect: () => [
        isA<ElectionFilterState>()
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.df)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.senator),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve restringir a Presidente ao retornar da UF estadual para BR',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.mg,
        selectedRole: ElectionRole.governor,
        availableRoles: [
          ElectionRole.governor,
          ElectionRole.senator,
          ElectionRole.federalDeputy,
          ElectionRole.stateDeputy,
        ],
      ),
      act: (bloc) => bloc.add(const ElectionFilterUfChanged(FederativeUnit.br)),
      expect: () => [
        isA<ElectionFilterState>()
            .having((s) => s.selectedUf, 'selectedUf', FederativeUnit.br)
            .having((s) => s.selectedRole, 'selectedRole', ElectionRole.president)
            .having((s) => s.availableRoles, 'availableRoles', [ElectionRole.president]),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve atualizar o cargo selecionado quando for compativel com a UF',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.rj,
        selectedRole: ElectionRole.governor,
        availableRoles: [
          ElectionRole.governor,
          ElectionRole.senator,
          ElectionRole.federalDeputy,
          ElectionRole.stateDeputy,
        ],
      ),
      act: (bloc) => bloc.add(const ElectionFilterRoleChanged(ElectionRole.federalDeputy)),
      expect: () => [
        isA<ElectionFilterState>().having(
          (s) => s.selectedRole,
          'selectedRole',
          ElectionRole.federalDeputy,
        ),
      ],
    );

    blocTest<ElectionFilterBloc, ElectionFilterState>(
      'deve ignorar tentativa de selecionar cargo incompativel com a UF',
      build: () => ElectionFilterBloc(getElectionsUseCase: mockGetElectionsUseCase),
      seed: () => const ElectionFilterState(
        status: ElectionFilterStatus.success,
        selectedElection: election2026,
        selectedUf: FederativeUnit.br,
        selectedRole: ElectionRole.president,
        availableRoles: [ElectionRole.president],
      ),
      act: (bloc) => bloc.add(const ElectionFilterRoleChanged(ElectionRole.governor)),
      expect: () => <ElectionFilterState>[],
    );
  });
}
