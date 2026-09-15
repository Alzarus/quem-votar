import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_state.dart';
import 'package:quem_votar/presentation/pages/candidate_detail_page.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_assets_section.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_civil_data.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_feedback_views.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_header.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_proposal_card.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_running_mates.dart';

class MockCandidateDetailBloc extends MockBloc<CandidateDetailEvent, CandidateDetailState>
    implements CandidateDetailBloc {}

class FakePageUrlLauncherService implements UrlLauncherService {
  String? openedUrl;
  bool shouldSucceed = true;

  @override
  Future<bool> launchCandidateUrl(String rawUrl) async {
    openedUrl = rawUrl;
    return shouldSucceed;
  }
}

void main() {
  late MockCandidateDetailBloc mockDetailBloc;

  const mockAssets = [
    CandidateAsset(
      orderIndex: 1,
      category: 'Apartamento',
      description: 'Apartamento 1002 Residencial',
      amount: 687091.02,
      updatedAt: '2026-08-26',
    ),
    CandidateAsset(
      orderIndex: 2,
      category: 'Veiculo automotor terrestre',
      description: 'Automovel Sedan 2024',
      amount: 105000.0,
      updatedAt: '2026-08-26',
    ),
  ];

  const mockRunningMates = [
    RunningMate(
      id: 12002,
      parentCandidateId: 12001,
      ballotNumber: 12,
      ballotName: 'ANA PAULA',
      fullName: 'ANA PAULA MATOS',
      partyAcronym: 'PDT',
      partyName: 'Partido Democratico Trabalhista',
      roleDescription: 'Vice-presidente',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/vice.jpg',
      isEligible: true,
    ),
  ];

  const mockDetail = CandidateDetail(
    id: 12001,
    ballotNumber: 12,
    ballotName: 'CIRO GOMES',
    fullName: 'CIRO FERREIRA GOMES',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PDT',
    partyName: 'Partido Democratico Trabalhista',
    coalitionName: 'PDT',
    photoUrl: 'https://divulgacandcontas.tse.jus.br/ciro.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido com base no art. 16 da Lei 9.504/97',
    totalAssetsAmount: 792091.02,
    birthDate: '1957-11-06',
    gender: 'MASC.',
    colorRace: 'BRANCA',
    maritalStatus: 'Divorciado(a)',
    educationLevel: 'Superior completo',
    occupation: 'Advogado',
    nationality: 'Brasileira nata',
    birthCity: 'Pindamonhangaba',
    birthState: 'SP',
    maxCampaignExpenseFirstTurn: 88944030.80,
    maxCampaignExpenseSecondTurn: 44472015.40,
    assets: mockAssets,
    runningMates: mockRunningMates,
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta.pdf',
  );

  setUpAll(() {
    registerFallbackValue(const CandidateDetailRefreshRequested());
    registerFallbackValue(
      const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.descendingValue),
    );
  });

  setUp(() {
    mockDetailBloc = MockCandidateDetailBloc();
  });

  Widget buildTestApp({
    CandidateDetailBloc? bloc,
    VoidCallback? onBack,
    VoidCallback? onOpenProposal,
    UrlLauncherService? urlLauncherService,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: MediaQuery(
        data: MediaQueryData(size: const Size(800, 1200), textScaler: textScaler),
        child: CandidateDetailPage(
          candidateDetailBloc: bloc ?? mockDetailBloc,
          onBack: onBack,
          onOpenProposal: onOpenProposal,
          urlLauncherService: urlLauncherService ?? const DefaultUrlLauncherService(),
        ),
      ),
    );
  }

  group('CandidateDetailPage - Estados de Interface', () {
    testWidgets('deve exibir CandidateDetailLoadingView quando status for loading e detalhe nulo', (
      tester,
    ) async {
      when(
        () => mockDetailBloc.state,
      ).thenReturn(CandidateDetailState.initial().copyWith(status: CandidateDetailStatus.loading));

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CandidateDetailLoadingView), findsOneWidget);
      expect(find.byType(CandidateDetailHeader), findsNothing);
    });

    testWidgets('deve exibir CandidateDetailErrorView quando status for failure e detalhe nulo', (
      tester,
    ) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.failure,
          failure: () => const NetworkFailure(
            message: 'Falha de conexao ao carregar detalhes.',
            operationalContext: 'test',
          ),
        ),
      );

      await tester.pumpWidget(buildTestApp());

      expect(find.byType(CandidateDetailErrorView), findsOneWidget);
      expect(find.text('Falha de conexao ao carregar detalhes.'), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('deve exibir todos os modulos informativos quando status for success', (
      tester,
    ) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(CandidateDetailHeader), findsOneWidget);
      expect(find.byType(CandidateDetailProposalCard), findsOneWidget);
      expect(find.byType(CandidateDetailCivilData), findsOneWidget);
      expect(find.byType(CandidateDetailRunningMates), findsOneWidget);
      expect(find.byType(CandidateDetailAssetsSection), findsOneWidget);
      expect(find.text('CIRO GOMES'), findsOneWidget);
      expect(find.text('ANA PAULA'), findsOneWidget);
    });
  });

  group('CandidateDetailPage - Interacoes e Callbacks', () {
    testWidgets('deve acionar callback onBack ao clicar no botao voltar da AppBar', (tester) async {
      var backCalled = false;
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp(onBack: () => backCalled = true));
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pump();

      expect(backCalled, isTrue);
    });

    testWidgets('deve conter RefreshIndicator para pull-to-refresh na ficha do candidato', (
      tester,
    ) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);
    });

    testWidgets('deve despachar CandidateDetailRefreshRequested ao clicar no retry de erro', (
      tester,
    ) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.failure,
          failure: () => const NetworkFailure(message: 'Erro de conexao', operationalContext: 't'),
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final retryButton = find.text('Tentar Novamente');
      expect(retryButton, findsOneWidget);
      await tester.tap(retryButton);
      await tester.pump();

      verify(() => mockDetailBloc.add(const CandidateDetailRefreshRequested())).called(1);
    });

    testWidgets(
      'deve despachar CandidateDetailAssetSortOptionChanged ao clicar em opcao de filtro',
      (tester) async {
        when(() => mockDetailBloc.state).thenReturn(
          CandidateDetailState.initial().copyWith(
            status: CandidateDetailStatus.success,
            candidateDetail: () => mockDetail,
            sortedAssets: mockAssets,
            totalAssetsAmount: 792091.02,
          ),
        );

        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        final menorValorChip = find.text('Menor Valor');
        expect(menorValorChip, findsOneWidget);
        await tester.ensureVisible(menorValorChip);
        await tester.pumpAndSettle();
        await tester.tap(menorValorChip);
        await tester.pump();

        verify(
          () => mockDetailBloc.add(
            const CandidateDetailAssetSortOptionChanged(CandidateAssetSortOption.ascendingValue),
          ),
        ).called(1);
      },
    );

    testWidgets('deve acionar onOpenProposal ao clicar no botao de proposta de governo', (
      tester,
    ) async {
      var proposalOpened = false;
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp(onOpenProposal: () => proposalOpened = true));
      await tester.pumpAndSettle();

      final proposalBtn = find.text('Acessar Proposta de Governo (PDF)');
      expect(proposalBtn, findsOneWidget);
      await tester.ensureVisible(proposalBtn);
      await tester.pumpAndSettle();
      await tester.tap(proposalBtn);
      await tester.pump();

      expect(proposalOpened, isTrue);
    });

    testWidgets('deve disparar urlLauncherService quando onOpenProposal nao for fornecido', (
      tester,
    ) async {
      final fakeLauncher = FakePageUrlLauncherService();
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp(urlLauncherService: fakeLauncher));
      await tester.pumpAndSettle();

      final proposalBtn = find.text('Acessar Proposta de Governo (PDF)');
      expect(proposalBtn, findsOneWidget);
      await tester.ensureVisible(proposalBtn);
      await tester.pumpAndSettle();
      await tester.tap(proposalBtn);
      await tester.pump();

      expect(fakeLauncher.openedUrl, equals(mockDetail.proposalDocumentUrl));
    });
  });

  group('CandidateDetailPage - Acessibilidade WCAG 2.1 AA', () {
    testWidgets('deve suportar TextScaler 2.0 sem overflow de leiaute', (tester) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp(textScaler: const TextScaler.linear(2.0)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CandidateDetailHeader), findsOneWidget);
    });

    testWidgets('alvo de toque do botao de retorno deve ter dimensao minima de 48x48dp', (
      tester,
    ) async {
      when(() => mockDetailBloc.state).thenReturn(
        CandidateDetailState.initial().copyWith(
          status: CandidateDetailStatus.success,
          candidateDetail: () => mockDetail,
          sortedAssets: mockAssets,
          totalAssetsAmount: 792091.02,
        ),
      );

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      final backButton = find.bySemanticsLabel('Voltar para listagem de candidatos');
      expect(backButton, findsOneWidget);

      final size = tester.getSize(backButton);
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });
  });
}
