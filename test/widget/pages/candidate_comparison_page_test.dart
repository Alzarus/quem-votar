import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_event.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_state.dart';
import 'package:quem_votar/presentation/pages/candidate_comparison_page.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';

class MockCandidateComparisonBloc
    extends MockBloc<CandidateComparisonEvent, CandidateComparisonState>
    implements CandidateComparisonBloc {}

void main() {
  late MockCandidateComparisonBloc mockComparisonBloc;

  const candidate1 = CandidateSummary(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Lula',
    fullName: 'Luiz Inacio Lula da Silva',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'Brasil da Esperanca',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 7423725.78,
  );

  const candidate2 = CandidateSummary(
    id: 102,
    ballotNumber: 22,
    ballotName: 'Bolsonaro',
    fullName: 'Jair Messias Bolsonaro',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PL',
    partyName: 'Partido Liberal',
    coalitionName: 'Pelo Bem do Brasil',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 2312554.00,
  );

  const detail1 = CandidateDetail(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Lula',
    fullName: 'Luiz Inacio Lula da Silva',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'Brasil da Esperanca',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 7423725.78,
    birthDate: '1945-10-27',
    gender: 'MASCULINO',
    colorRace: 'BRANCA',
    maritalStatus: 'CASADO(A)',
    educationLevel: 'ENSINO FUNDAMENTAL INCOMPLETO',
    occupation: 'TORNEIRO MECANICO',
    nationality: 'BRASILEIRA NATA',
    birthCity: 'GARANHUNS',
    birthState: 'PE',
    maxCampaignExpenseFirstTurn: 88944030.80,
    maxCampaignExpenseSecondTurn: 44472015.40,
    assets: [],
    runningMates: [],
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta_lula.pdf',
  );

  const detail2 = CandidateDetail(
    id: 102,
    ballotNumber: 22,
    ballotName: 'Bolsonaro',
    fullName: 'Jair Messias Bolsonaro',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PL',
    partyName: 'Partido Liberal',
    coalitionName: 'Pelo Bem do Brasil',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 2312554.00,
    birthDate: '1955-03-21',
    gender: 'MASCULINO',
    colorRace: 'BRANCA',
    maritalStatus: 'CASADO(A)',
    educationLevel: 'SUPERIOR COMPLETO',
    occupation: 'MILITAR REFORMADO',
    nationality: 'BRASILEIRA NATA',
    birthCity: 'GLICERIO',
    birthState: 'SP',
    maxCampaignExpenseFirstTurn: 88944030.80,
    maxCampaignExpenseSecondTurn: 44472015.40,
    assets: [],
    runningMates: [],
    proposalDocumentUrl: 'https://divulgacandcontas.tse.jus.br/proposta_bolsonaro.pdf',
  );

  setUp(() {
    mockComparisonBloc = MockCandidateComparisonBloc();
  });

  Widget buildPage() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: CandidateComparisonPage(comparisonBloc: mockComparisonBloc),
    );
  }

  group('CandidateComparisonPage - Renderizacao e Matriz Analitica', () {
    testWidgets('deve renderizar estado vazio quando nao houver candidatos selecionados', (
      tester,
    ) async {
      when(() => mockComparisonBloc.state).thenReturn(const CandidateComparisonState());

      await tester.pumpWidget(buildPage());
      expect(find.text('Nenhuma candidatura selecionada para comparacao.'), findsOneWidget);
    });

    testWidgets('deve renderizar cabecalhos e abas quando houver candidaturas selecionadas', (
      tester,
    ) async {
      when(() => mockComparisonBloc.state).thenReturn(
        const CandidateComparisonState(
          selectedCandidates: [candidate1, candidate2],
          candidateDetails: {101: detail1, 102: detail2},
          status: CandidateComparisonStatus.success,
        ),
      );

      await tester.pumpWidget(buildPage());

      expect(find.text('Comparador de Candidaturas'), findsOneWidget);
      expect(find.text('2 candidaturas em analise comparativa'), findsOneWidget);
      expect(find.text('Lula'), findsWidgets);
      expect(find.text('Bolsonaro'), findsWidgets);

      // Abas
      expect(find.text('Visao Geral'), findsOneWidget);
      expect(find.text('Patrimonio'), findsOneWidget);
      expect(find.text('Gastos e Perfil'), findsOneWidget);
      expect(find.text('Propostas'), findsOneWidget);
    });

    testWidgets('deve navegar entre abas ao clicar na TabBar', (tester) async {
      when(() => mockComparisonBloc.state).thenReturn(
        const CandidateComparisonState(
          selectedCandidates: [candidate1, candidate2],
          candidateDetails: {101: detail1, 102: detail2},
          status: CandidateComparisonStatus.success,
        ),
      );

      await tester.pumpWidget(buildPage());

      // Clica na aba Patrimonio
      await tester.tap(find.text('Patrimonio'));
      await tester.pumpAndSettle();

      expect(find.text('Patrimonio Declarado a Justica Eleitoral'), findsOneWidget);

      // Clica na aba Gastos e Perfil
      await tester.tap(find.text('Gastos e Perfil'));
      await tester.pumpAndSettle();

      expect(find.text('Limites de Gastos de Campanha (TSE)'), findsOneWidget);
    });

    testWidgets('deve despachar CandidateComparisonSelectionCleared ao clicar em Limpar', (
      tester,
    ) async {
      when(() => mockComparisonBloc.state).thenReturn(
        const CandidateComparisonState(
          selectedCandidates: [candidate1, candidate2],
          status: CandidateComparisonStatus.success,
        ),
      );

      await tester.pumpWidget(buildPage());

      await tester.tap(find.text('Limpar'));
      await tester.pump();

      verify(() => mockComparisonBloc.add(const CandidateComparisonSelectionCleared())).called(1);
    });
  });
}
