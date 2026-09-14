import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/main.dart';

class MockGetElectionsUseCase extends Mock implements GetElectionsUseCase {}

class MockGetCandidatesListUseCase extends Mock implements GetCandidatesListUseCase {}

class MockGetCandidateDetailUseCase extends Mock implements GetCandidateDetailUseCase {}

void main() {
  late MockGetElectionsUseCase mockGetElections;
  late MockGetCandidatesListUseCase mockGetCandidatesList;
  late MockGetCandidateDetailUseCase mockGetCandidateDetail;

  const testElection = Election(
    id: 2040602026,
    year: 2026,
    name: 'Eleições Gerais 2026',
    description: 'Eleição Geral Federal e Estadual 2026',
    type: 'ORDINARIA',
    scope: 'FEDERAL',
    electionDate: '04/10/2026',
  );

  const nationalCandidates = [
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
  ];

  const acGovernorCandidates = [
    CandidateSummary(
      id: 20001,
      ballotNumber: 11,
      ballotName: 'GLADSON CAMELI',
      fullName: 'GLADSON DE LIMA CAMELI',
      roleCode: 3,
      roleDescription: 'Governador',
      partyAcronym: 'PP',
      partyName: 'Progressistas',
      coalitionName: 'AVANCA ACRE',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/gladson.jpg',
      registrationStatus: RegistrationStatus.deferred,
      rawStatusDescription: 'DEFERIDO',
      totalAssetsAmount: 5128000.0,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(
      const GetCandidatesListParams(year: 2026, ufOrMun: 'BR', electionId: 2040602026, roleCode: 1),
    );
  });

  setUp(() {
    mockGetElections = MockGetElectionsUseCase();
    mockGetCandidatesList = MockGetCandidatesListUseCase();
    mockGetCandidateDetail = MockGetCandidateDetailUseCase();

    when(
      () => mockGetElections.execute(),
    ).thenAnswer((_) async => const Result.success([testElection]));

    when(
      () => mockGetCandidatesList.execute(any()),
    ).thenAnswer((_) async => const Result.success(nationalCandidates));
  });

  Widget buildTestFlowApp() {
    return QuemVotarApp(
      getElectionsUseCase: mockGetElections,
      getCandidatesListUseCase: mockGetCandidatesList,
      getCandidateDetailUseCase: mockGetCandidateDetail,
    );
  }

  group('Fluxo de Tela - Filtros, Busca Textual, Vazio e Resiliencia', () {
    testWidgets('deve sincronizar filtros territoriais e de cargo atualizando a listagem', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      when(
        () => mockGetCandidatesList.execute(
          any(
            that: isA<GetCandidatesListParams>()
                .having((p) => p.ufOrMun, 'ufOrMun', 'AC')
                .having((p) => p.roleCode, 'roleCode', 3),
          ),
        ),
      ).thenAnswer((_) async => const Result.success(acGovernorCandidates));

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      expect(find.text('LULA'), findsOneWidget);

      final ufDropdown = find.widgetWithText(DropdownButton<FederativeUnit>, 'BR - Brasil');
      expect(ufDropdown, findsOneWidget);
      await tester.tap(ufDropdown);
      await tester.pumpAndSettle();

      final acOption = find.text('AC - Acre').last;
      await tester.tap(acOption);
      await tester.pumpAndSettle();

      expect(find.text('GLADSON CAMELI'), findsOneWidget);
      expect(find.text('PP - 11'), findsOneWidget);
    });

    testWidgets('deve filtrar candidatos por busca textual com debounce e restaurar na limpeza', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'bolso');

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('LULA'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('LULA'), findsNothing);
      expect(find.text('BOLSONARO'), findsOneWidget);

      final clearButton = find.byIcon(Icons.clear);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);
    });

    testWidgets('deve renderizar estado vazio em busca inexistente e resetar via Limpar Filtros', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'candidato_inexistente_999');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Nenhum candidato encontrado'), findsOneWidget);

      final clearFiltersButton = find.text('Limpar Filtros');
      expect(clearFiltersButton, findsOneWidget);
      await tester.tap(clearFiltersButton);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);
    });

    testWidgets(
      'deve renderizar tela de erro na listagem e recuperar apos acionar Tentar Novamente',
      (tester) async {
        when(() => mockGetCandidatesList.execute(any())).thenAnswer(
          (_) async => const Result.failure(
            ServerFailure(
              message: 'Tempo limite excedido na Justica Eleitoral.',
              operationalContext: 'MockGetCandidatesList',
            ),
          ),
        );

        await tester.pumpWidget(buildTestFlowApp());
        await tester.pumpAndSettle();

        expect(find.text('Não foi possível carregar os dados'), findsOneWidget);
        expect(find.text('Tempo limite excedido na Justica Eleitoral.'), findsOneWidget);

        final retryButton = find.text('Tentar Novamente');
        expect(retryButton, findsOneWidget);

        when(
          () => mockGetCandidatesList.execute(any()),
        ).thenAnswer((_) async => const Result.success(nationalCandidates));

        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        expect(find.text('LULA'), findsOneWidget);
        expect(find.text('BOLSONARO'), findsOneWidget);
      },
    );
  });
}
