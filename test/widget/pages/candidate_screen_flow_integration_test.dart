import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/core/utils/result.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/main.dart';
import 'package:quem_votar/presentation/widgets/candidate_card.dart';

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
    description: 'Eleição Geral Federal 2026',
    type: 'ORDINARIA',
    scope: 'FEDERAL',
    electionDate: '04/10/2026',
  );

  const testCandidates = [
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
      totalAssetsAmount: 6292091.02,
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

  const testAssets = [
    CandidateAsset(
      orderIndex: 1,
      category: 'Apartamento',
      description: 'Apartamento 1002 Residencial',
      amount: 687091.02,
      updatedAt: '2026-08-26',
    ),
    CandidateAsset(
      orderIndex: 2,
      category: 'Aplicacao financeira',
      description: 'Previdencia privada VGBL',
      amount: 5500000.0,
      updatedAt: '2026-08-26',
    ),
    CandidateAsset(
      orderIndex: 3,
      category: 'Veiculo automotor terrestre',
      description: 'Automovel Sedan 2024',
      amount: 105000.0,
      updatedAt: '2026-08-26',
    ),
  ];

  const testRunningMates = [
    RunningMate(
      id: 10002,
      parentCandidateId: 10001,
      ballotNumber: 13,
      ballotName: 'GERALDO ALCKMIN',
      fullName: 'GERALDO JOSE RODRIGUES ALCKMIN FILHO',
      partyAcronym: 'PSB',
      partyName: 'Partido Socialista Brasileiro',
      roleDescription: 'Vice-presidente',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/alckmin.jpg',
      isEligible: true,
    ),
  ];

  const testCandidateDetail = CandidateDetail(
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
    totalAssetsAmount: 6292091.02,
    birthDate: '1945-10-27',
    gender: 'MASC.',
    colorRace: 'BRANCA',
    maritalStatus: 'CASADO(A)',
    educationLevel: 'ENSINO FUNDAMENTAL COMPLETO',
    occupation: 'APOSENTADO (EXCETO SERVIDOR PUBLICO)',
    nationality: 'BRASILEIRA NATA',
    birthCity: 'CAETES',
    birthState: 'PE',
    maxCampaignExpenseFirstTurn: 130000000.0,
    maxCampaignExpenseSecondTurn: 65000000.0,
    assets: testAssets,
    runningMates: testRunningMates,
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta_lula.pdf',
  );

  setUpAll(() {
    registerFallbackValue(
      const GetCandidatesListParams(year: 2026, ufOrMun: 'BR', electionId: 2040602026, roleCode: 1),
    );
    registerFallbackValue(
      const GetCandidateDetailParams(
        year: 2026,
        ufOrMun: 'BR',
        electionId: 2040602026,
        candidateId: 10001,
      ),
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
    ).thenAnswer((_) async => const Result.success(testCandidates));

    when(
      () => mockGetCandidateDetail.execute(any()),
    ).thenAnswer((_) async => const Result.success(testCandidateDetail));
  });

  Widget buildTestFlowApp() {
    return QuemVotarApp(
      getElectionsUseCase: mockGetElections,
      getCandidatesListUseCase: mockGetCandidatesList,
      getCandidateDetailUseCase: mockGetCandidateDetail,
    );
  }

  group('Fluxo de Tela - Integracao Listagem -> Detalhes -> Retorno', () {
    testWidgets('deve navegar da listagem para detalhes e retornar mantendo estado', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      expect(find.text('Quem Votar'), findsOneWidget);
      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);

      final lulaCard = find.widgetWithText(CandidateCard, 'LULA');
      expect(lulaCard, findsOneWidget);
      await tester.tap(lulaCard);
      await tester.pumpAndSettle();

      expect(find.text('Ficha da Candidatura'), findsOneWidget);
      expect(find.text('LUIZ INACIO LULA DA SILVA'), findsOneWidget);
      expect(find.text('GERALDO ALCKMIN'), findsOneWidget);
      expect(find.textContaining('Vice-presidente'), findsOneWidget);
      expect(find.text('Diretrizes e Plano de Governo'), findsOneWidget);
      expect(find.text('Acessar Proposta de Governo (PDF)'), findsOneWidget);
      expect(find.text('Patrimonio Declarado'), findsOneWidget);
      expect(find.text('Apartamento 1002 Residencial'), findsOneWidget);

      final highestOption = find.text('Maior Valor');
      if (highestOption.evaluate().isNotEmpty) {
        await tester.scrollUntilVisible(
          highestOption,
          200.0,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(highestOption);
        await tester.pumpAndSettle();
      }

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Ficha da Candidatura'), findsNothing);
      expect(find.text('Quem Votar'), findsOneWidget);
      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('BOLSONARO'), findsOneWidget);
    });

    testWidgets('deve executar fluxo completo de navegacao em viewport compacto mobile', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      expect(find.text('Quem Votar'), findsOneWidget);
      expect(find.text('LULA'), findsOneWidget);

      await tester.tap(find.widgetWithText(CandidateCard, 'LULA'));
      await tester.pumpAndSettle();

      expect(find.text('Ficha da Candidatura'), findsOneWidget);
      expect(find.text('LUIZ INACIO LULA DA SILVA'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Ficha da Candidatura'), findsNothing);
      expect(find.text('LULA'), findsOneWidget);
    });

    testWidgets('deve exibir tela de erro nos detalhes e recuperar via repeticao', (tester) async {
      when(() => mockGetCandidateDetail.execute(any())).thenAnswer(
        (_) async => const Result.failure(
          ServerFailure(
            message: 'Instabilidade no cartorio digital do TSE.',
            operationalContext: 'MockGetCandidateDetail',
          ),
        ),
      );

      await tester.pumpWidget(buildTestFlowApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CandidateCard, 'LULA'));
      await tester.pumpAndSettle();

      expect(find.text('Ficha da Candidatura'), findsOneWidget);
      expect(find.text('Instabilidade no cartorio digital do TSE.'), findsOneWidget);

      final retryButton = find.text('Tentar Novamente');
      expect(retryButton, findsOneWidget);

      when(
        () => mockGetCandidateDetail.execute(any()),
      ).thenAnswer((_) async => const Result.success(testCandidateDetail));

      await tester.tap(retryButton);
      await tester.pumpAndSettle();

      expect(find.text('LUIZ INACIO LULA DA SILVA'), findsOneWidget);
    });
  });
}
