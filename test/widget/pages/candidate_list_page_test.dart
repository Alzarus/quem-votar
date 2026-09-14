import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_state.dart';
import 'package:quem_votar/presentation/pages/candidate_list_page.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_card.dart';
import 'package:quem_votar/presentation/widgets/candidate_list_feedback_views.dart';

class MockElectionFilterBloc extends MockBloc<ElectionFilterEvent, ElectionFilterState>
    implements ElectionFilterBloc {}

class MockCandidateListBloc extends MockBloc<CandidateListEvent, CandidateListState>
    implements CandidateListBloc {}

void main() {
  late MockElectionFilterBloc mockFilterBloc;
  late MockCandidateListBloc mockListBloc;

  const mockElection = Election(
    id: 2040602026,
    year: 2026,
    name: 'Eleições Gerais 2026',
    description: 'Eleição Geral Federal 2026',
    type: 'ORDINARIA',
    scope: 'FEDERAL',
    electionDate: '04/10/2026',
  );

  const mockCandidates = [
    CandidateSummary(
      id: 10001,
      ballotNumber: 13,
      ballotName: 'LULA',
      fullName: 'LUIZ INACIO LULA DA SILVA',
      roleCode: 1,
      roleDescription: 'Presidente',
      partyAcronym: 'PT',
      partyName: 'Partido dos Trabalhadores',
      coalitionName: 'BRASIL DA ESPERANCA',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/lula.jpg',
      registrationStatus: RegistrationStatus.deferred,
      rawStatusDescription: 'DEFERIDO',
      totalAssetsAmount: 7423725.78,
    ),
    CandidateSummary(
      id: 10002,
      ballotNumber: 22,
      ballotName: 'BOLSONARO',
      fullName: 'JAIR MESSIAS BOLSONARO',
      roleCode: 1,
      roleDescription: 'Presidente',
      partyAcronym: 'PL',
      partyName: 'Partido Liberal',
      coalitionName: 'PELO BEM DO BRASIL',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/bolsonaro.jpg',
      registrationStatus: RegistrationStatus.deferred,
      rawStatusDescription: 'DEFERIDO',
      totalAssetsAmount: 2312000.0,
    ),
    CandidateSummary(
      id: 10003,
      ballotNumber: 12,
      ballotName: 'CIRO GOMES',
      fullName: 'CIRO FERREIRA GOMES',
      roleCode: 1,
      roleDescription: 'Presidente',
      partyAcronym: 'PDT',
      partyName: 'Partido Democratico Trabalhista',
      coalitionName: 'PARTIDO ISOLADO',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/ciro.jpg',
      registrationStatus: RegistrationStatus.deferred,
      rawStatusDescription: 'DEFERIDO',
      totalAssetsAmount: 3000000.0,
    ),
  ];

  const standardFilterState = ElectionFilterState(
    status: ElectionFilterStatus.success,
    elections: [mockElection],
    selectedElection: mockElection,
    availableUfs: [FederativeUnit.br, FederativeUnit.sp],
    selectedUf: FederativeUnit.br,
    availableRoles: [ElectionRole.president],
    selectedRole: ElectionRole.president,
  );

  setUpAll(() {
    registerFallbackValue(const ElectionFilterStarted());
    registerFallbackValue(
      const CandidateListLoadStarted(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 2040602026,
        roleCode: 1,
      ),
    );
    registerFallbackValue(const CandidateListSearchQueryChanged(''));
    registerFallbackValue(const CandidateListSortOptionChanged(CandidateSortOption.alphabetical));
    registerFallbackValue(const CandidateListPartyFilterChanged(null));
  });

  setUp(() {
    mockFilterBloc = MockElectionFilterBloc();
    mockListBloc = MockCandidateListBloc();

    when(() => mockFilterBloc.state).thenReturn(standardFilterState);
    when(() => mockFilterBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockListBloc.state).thenReturn(
      const CandidateListState(
        status: CandidateListStatus.success,
        allCandidates: mockCandidates,
        filteredCandidates: mockCandidates,
        searchQuery: '',
        sortOption: CandidateSortOption.alphabetical,
      ),
    );
    when(() => mockListBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildPage({
    Size screenSize = const Size(400, 800),
    TextScaler textScaler = TextScaler.noScaling,
    ValueChanged<CandidateSummary>? onCandidateSelected,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: MediaQuery(
        data: MediaQueryData(size: screenSize, textScaler: textScaler),
        child: CandidateListPage(
          electionFilterBloc: mockFilterBloc,
          candidateListBloc: mockListBloc,
          onCandidateSelected: onCandidateSelected,
        ),
      ),
    );
  }

  group('CandidateListPage - Responsividade e Breakpoints', () {
    testWidgets('deve renderizar em coluna unica em telas compactas (<600dp)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPage(screenSize: const Size(360, 640)));
      await tester.pumpAndSettle();

      expect(find.byType(CandidateCard), findsAtLeastNWidgets(2));
      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('CIRO GOMES'), findsOneWidget);
    });

    testWidgets('deve renderizar em 2 colunas em telas medias (600 a 840dp)', (tester) async {
      tester.view.physicalSize = const Size(720, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPage(screenSize: const Size(720, 1024)));
      await tester.pumpAndSettle();

      expect(find.byType(CandidateCard), findsNWidgets(3));
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('deve renderizar em 3 colunas em telas expandidas (>840dp)', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildPage(screenSize: const Size(1200, 800)));
      await tester.pumpAndSettle();

      expect(find.byType(CandidateCard), findsNWidgets(3));
    });
  });

  group('CandidateListPage - Estados de Interface', () {
    testWidgets('deve exibir CandidateListLoadingView quando status for loading', (tester) async {
      when(
        () => mockListBloc.state,
      ).thenReturn(CandidateListState.initial().copyWith(status: CandidateListStatus.loading));

      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.byType(CandidateListLoadingView), findsOneWidget);
      expect(find.byType(CandidateCard), findsNothing);
    });

    testWidgets('deve exibir CandidateListErrorView com retry quando status for failure', (
      tester,
    ) async {
      when(() => mockListBloc.state).thenReturn(
        CandidateListState.initial().copyWith(
          status: CandidateListStatus.failure,
          failure: () =>
              const ServerFailure(message: 'Erro ao conectar ao TSE.', operationalContext: 'test'),
        ),
      );

      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.byType(CandidateListErrorView), findsOneWidget);
      expect(find.textContaining('Erro ao conectar ao TSE.'), findsOneWidget);

      await tester.tap(find.text('Tentar Novamente'));
      await tester.pump();

      verify(() => mockListBloc.add(any())).called(greaterThanOrEqualTo(1));
    });

    testWidgets('deve exibir CandidateListEmptyView quando nao houver resultados', (tester) async {
      when(() => mockListBloc.state).thenReturn(
        CandidateListState.initial().copyWith(
          status: CandidateListStatus.success,
          allCandidates: const [],
          filteredCandidates: const [],
          searchQuery: 'inexistente',
        ),
      );

      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.byType(CandidateListEmptyView), findsOneWidget);
      expect(find.text('Limpar Filtros'), findsOneWidget);

      await tester.tap(find.text('Limpar Filtros'));
      await tester.pump();

      verify(
        () => mockListBloc.add(const CandidateListSearchQueryChanged('')),
      ).called(greaterThanOrEqualTo(1));
    });
  });

  group('CandidateListPage - Interacoes e Callbacks', () {
    testWidgets('deve propagar clique no cartao do candidato', (tester) async {
      CandidateSummary? selected;
      await tester.pumpWidget(buildPage(onCandidateSelected: (c) => selected = c));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LULA'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected?.ballotName, 'LULA');
    });

    testWidgets('deve despachar evento de busca textual ao digitar', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Lula');
      await tester.pump();

      verify(() => mockListBloc.add(const CandidateListSearchQueryChanged('Lula'))).called(1);
    });

    testWidgets('deve despachar evento de refresh ao clicar no botao da AppBar', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final refreshBtn = find.byTooltip('Atualizar dados');
      expect(refreshBtn, findsOneWidget);

      await tester.tap(refreshBtn);
      await tester.pump();

      verify(() => mockListBloc.add(any())).called(greaterThanOrEqualTo(1));
    });
  });

  group('CandidateListPage - Acessibilidade WCAG 2.1 AA', () {
    testWidgets('deve suportar TextScaler 2.0 sem overflow de leiaute', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildPage(screenSize: const Size(400, 800), textScaler: const TextScaler.linear(2.0)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('alvo de toque do botao de refresh deve ser no minimo 48x48dp', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final refreshBtnFinder = find.byTooltip('Atualizar dados');
      final size = tester.getSize(refreshBtnFinder);

      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });
  });
}
