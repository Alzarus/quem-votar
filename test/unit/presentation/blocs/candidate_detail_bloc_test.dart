import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_state.dart';

class MockGetCandidateDetailUseCase extends Mock implements GetCandidateDetailUseCase {}

class FakeGetCandidateDetailParams extends Fake implements GetCandidateDetailParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetCandidateDetailParams());
  });

  late MockGetCandidateDetailUseCase mockUseCase;

  const assetVeiculo = CandidateAsset(
    orderIndex: 1,
    category: 'Veiculo automotor',
    description: 'Automovel SUV 2022',
    amount: 150000.0,
    updatedAt: '2026-08-15',
  );

  const assetImovel = CandidateAsset(
    orderIndex: 2,
    category: 'Apartamento',
    description: 'Apartamento residencial em Brasilia',
    amount: 850000.0,
    updatedAt: '2026-08-15',
  );

  const assetInvestimento = CandidateAsset(
    orderIndex: 3,
    category: 'Fundo de Investimento',
    description: 'Cotas de fundo de renda fixa',
    amount: 300000.0,
    updatedAt: '2026-08-15',
  );

  const candidateDetailMock = CandidateDetail(
    id: 280001612393,
    ballotNumber: 12,
    ballotName: 'CIRO GOMES',
    fullName: 'CIRO FERREIRA GOMES',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PDT',
    partyName: 'Partido Democratico Trabalhista',
    coalitionName: 'PDT',
    photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 1300000.0,
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
    maxCampaignExpenseSecondTurn: 44472015.4,
    assets: [assetVeiculo, assetImovel, assetInvestimento],
    runningMates: [
      RunningMate(
        id: 280001612394,
        ballotNumber: 12,
        ballotName: 'ANA PAULA',
        fullName: 'ANA PAULA PRATES MATOS',
        partyAcronym: 'PDT',
        partyName: 'Partido Democratico Trabalhista',
        roleDescription: 'Vice-Presidente',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/12_vice.jpg',
        isEligible: true,
      ),
    ],
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta_12.pdf',
  );

  const candidateWithoutAssetsMock = CandidateDetail(
    id: 280001612395,
    ballotNumber: 50,
    ballotName: 'CANDIDATO SEM BENS',
    fullName: 'CANDIDATO SEM PATRIMONIO OFICIAL',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PSOL',
    partyName: 'Partido Socialismo e Liberdade',
    coalitionName: 'PSOL/REDE',
    photoUrl: 'https://divulgacandcontas.tse.jus.br/foto/50.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 0.0,
    birthDate: '1980-01-01',
    gender: 'FEM.',
    colorRace: 'PARDA',
    maritalStatus: 'Solteiro(a)',
    educationLevel: 'Superior completo',
    occupation: 'Professor',
    nationality: 'Brasileira nata',
    birthCity: 'SALVADOR',
    birthState: 'BA',
    maxCampaignExpenseFirstTurn: 88944030.8,
    assets: [],
    runningMates: [],
  );

  setUp(() {
    mockUseCase = MockGetCandidateDetailUseCase();
  });

  group('CandidateDetailBloc - Inicializacao e Estado Inicial', () {
    test('estado inicial deve possuir status initial, sem ficha e ordenacao decrescente', () {
      final bloc = CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      expect(bloc.state.status, equals(CandidateDetailStatus.initial));
      expect(bloc.state.candidateDetail, isNull);
      expect(bloc.state.sortedAssets, isEmpty);
      expect(bloc.state.totalAssetsAmount, equals(0.0));
      expect(bloc.state.assetSortOption, equals(CandidateAssetSortOption.descendingValue));
      expect(bloc.state.isRefreshing, isFalse);
      expect(bloc.state.failure, isNull);
      expect(bloc.state.hasAssets, isFalse);
      expect(bloc.state.assetsCount, equals(0));
      expect(bloc.state.hasRunningMates, isFalse);
      expect(bloc.state.hasProposalDocument, isFalse);
      bloc.close();
    });

    test('getters de conveniencia devem computar propriedades corretamente', () {
      final state = CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: candidateDetailMock.assets,
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
      );

      expect(state.hasAssets, isTrue);
      expect(state.assetsCount, equals(3));
      expect(state.hasRunningMates, isTrue);
      expect(state.hasProposalDocument, isTrue);
      expect(state.isSecondTurnExpenseAvailable, isTrue);
    });
  });

  group('CandidateDetailBloc - Carregamento de Ficha (CandidateDetailLoadStarted)', () {
    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve emitir [loading, success] com bens ordenados por maior valor venal por padrao',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(candidateDetailMock));
        return CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const CandidateDetailLoadStarted(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 20322002026,
          candidateId: 280001612393,
        ),
      ),
      expect: () => [
        isA<CandidateDetailState>().having(
          (s) => s.status,
          'status',
          CandidateDetailStatus.loading,
        ),
        isA<CandidateDetailState>()
            .having((s) => s.status, 'status', CandidateDetailStatus.success)
            .having((s) => s.candidateDetail, 'candidateDetail', candidateDetailMock)
            .having((s) => s.totalAssetsAmount, 'totalAssetsAmount', 1300000.0)
            .having((s) => s.sortedAssets, 'sortedAssets ordenados decrescente', [
              assetImovel,
              assetInvestimento,
              assetVeiculo,
            ])
            .having((s) => s.activeYear, 'activeYear', 2026)
            .having((s) => s.activeUfOrMun, 'activeUfOrMun', 'BR')
            .having((s) => s.activeElectionId, 'activeElectionId', 20322002026)
            .having((s) => s.activeCandidateId, 'activeCandidateId', 280001612393),
      ],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve emitir [loading, failure] quando caso de uso retornar falha tipada',
      build: () {
        const failure = ServerFailure(
          message: 'Falha perimetral Akamai',
          operationalContext: 'CandidateRepository.getCandidateDetail',
        );
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.failure(failure));
        return CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const CandidateDetailLoadStarted(
          year: 2026,
          ufOrMun: 'BR',
          electionId: 20322002026,
          candidateId: 280001612393,
        ),
      ),
      expect: () => [
        isA<CandidateDetailState>().having(
          (s) => s.status,
          'status',
          CandidateDetailStatus.loading,
        ),
        isA<CandidateDetailState>()
            .having((s) => s.status, 'status', CandidateDetailStatus.failure)
            .having((s) => s.failure?.message, 'failure.message', 'Falha perimetral Akamai'),
      ],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve processar com sucesso candidatura sem bens declarados',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(candidateWithoutAssetsMock));
        return CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(
        const CandidateDetailLoadStarted(
          year: 2026,
          ufOrMun: 'BA',
          electionId: 20322002026,
          candidateId: 280001612395,
        ),
      ),
      expect: () => [
        isA<CandidateDetailState>().having(
          (s) => s.status,
          'status',
          CandidateDetailStatus.loading,
        ),
        isA<CandidateDetailState>()
            .having((s) => s.status, 'status', CandidateDetailStatus.success)
            .having((s) => s.candidateDetail, 'candidateDetail', candidateWithoutAssetsMock)
            .having((s) => s.sortedAssets, 'sortedAssets', isEmpty)
            .having((s) => s.totalAssetsAmount, 'totalAssetsAmount', 0.0),
      ],
    );
  });

  group('CandidateDetailBloc - Reordenacao Patrimonial (Sort Option)', () {
    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve reordenar bens por menor valor venal (ascendingValue)',
      build: () => CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: [assetImovel, assetInvestimento, assetVeiculo],
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
      ),
      act: (bloc) => bloc.add(
        const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.ascendingValue),
      ),
      expect: () => [
        isA<CandidateDetailState>()
            .having(
              (s) => s.assetSortOption,
              'assetSortOption',
              CandidateAssetSortOption.ascendingValue,
            )
            .having((s) => s.sortedAssets, 'sortedAssets crescente', [
              assetVeiculo,
              assetInvestimento,
              assetImovel,
            ]),
      ],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve reordenar bens pela ordem original de registro (originalOrder)',
      build: () => CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: [assetImovel, assetInvestimento, assetVeiculo],
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
      ),
      act: (bloc) => bloc.add(
        const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.originalOrder),
      ),
      expect: () => [
        isA<CandidateDetailState>()
            .having(
              (s) => s.assetSortOption,
              'assetSortOption',
              CandidateAssetSortOption.originalOrder,
            )
            .having((s) => s.sortedAssets, 'sortedAssets ordem original', [
              assetVeiculo,
              assetImovel,
              assetInvestimento,
            ]),
      ],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve reordenar bens por ordem alfabetica da categoria (category)',
      build: () => CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase),
      seed: () => const CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: [assetImovel, assetInvestimento, assetVeiculo],
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
      ),
      act: (bloc) =>
          bloc.add(const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.category)),
      expect: () => [
        isA<CandidateDetailState>()
            .having((s) => s.assetSortOption, 'assetSortOption', CandidateAssetSortOption.category)
            .having(
              (s) => s.sortedAssets,
              'sortedAssets alfabetica categoria',
              [assetImovel, assetInvestimento, assetVeiculo], // Apartamento, Fundo..., Veiculo...
            ),
      ],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve alterar assetSortOption sem erro quando candidateDetail for nulo',
      build: () => CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase),
      act: (bloc) => bloc.add(
        const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.ascendingValue),
      ),
      expect: () => [
        isA<CandidateDetailState>().having(
          (s) => s.assetSortOption,
          'assetSortOption',
          CandidateAssetSortOption.ascendingValue,
        ),
      ],
    );
  });

  group('CandidateDetailBloc - Revalidacao sob Demanda (CandidateDetailRefreshRequested)', () {
    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve emitir isRefreshing: true preservando os dados da ficha durante atualizacao',
      build: () {
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.success(candidateDetailMock));
        return CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      },
      seed: () => const CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: [assetImovel, assetInvestimento, assetVeiculo],
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
        activeYear: 2026,
        activeUfOrMun: 'BR',
        activeElectionId: 20322002026,
        activeCandidateId: 280001612393,
      ),
      act: (bloc) => bloc.add(const CandidateDetailRefreshRequested()),
      expect: () => [
        isA<CandidateDetailState>()
            .having((s) => s.isRefreshing, 'isRefreshing', isTrue)
            .having((s) => s.candidateDetail, 'candidateDetail preservado', candidateDetailMock),
        isA<CandidateDetailState>()
            .having((s) => s.isRefreshing, 'isRefreshing', isFalse)
            .having((s) => s.status, 'status', CandidateDetailStatus.success)
            .having((s) => s.candidateDetail, 'candidateDetail', candidateDetailMock),
      ],
      verify: (_) {
        verify(
          () => mockUseCase.execute(
            any(
              that: isA<GetCandidateDetailParams>().having(
                (p) => p.forceRefresh,
                'forceRefresh',
                isTrue,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve ignorar refresh silenciosamente quando nenhum parametro ativo estiver definido',
      build: () => CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase),
      act: (bloc) => bloc.add(const CandidateDetailRefreshRequested()),
      expect: () => <CandidateDetailState>[],
    );

    blocTest<CandidateDetailBloc, CandidateDetailState>(
      'deve emitir failure quando a revalidacao remota falhar',
      build: () {
        const failure = NetworkFailure(
          message: 'Conexao de rede interrompida',
          operationalContext: 'CandidateRepository.getCandidateDetail',
        );
        when(
          () => mockUseCase.execute(any()),
        ).thenAnswer((_) async => const Result.failure(failure));
        return CandidateDetailBloc(getCandidateDetailUseCase: mockUseCase);
      },
      seed: () => const CandidateDetailState(
        status: CandidateDetailStatus.success,
        candidateDetail: candidateDetailMock,
        sortedAssets: [assetImovel, assetInvestimento, assetVeiculo],
        totalAssetsAmount: 1300000.0,
        assetSortOption: CandidateAssetSortOption.descendingValue,
        activeYear: 2026,
        activeUfOrMun: 'BR',
        activeElectionId: 20322002026,
        activeCandidateId: 280001612393,
      ),
      act: (bloc) => bloc.add(const CandidateDetailRefreshRequested()),
      expect: () => [
        isA<CandidateDetailState>().having((s) => s.isRefreshing, 'isRefreshing', isTrue),
        isA<CandidateDetailState>()
            .having((s) => s.status, 'status', CandidateDetailStatus.failure)
            .having((s) => s.isRefreshing, 'isRefreshing', isFalse)
            .having((s) => s.failure?.message, 'failure.message', 'Conexao de rede interrompida'),
      ],
    );
  });
}
