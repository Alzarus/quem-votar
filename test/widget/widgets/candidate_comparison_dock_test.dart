import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_comparison_dock.dart';

void main() {
  const candidateA = CandidateSummary(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Candidato Alpha',
    fullName: 'Nome Completo Alpha',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'Coligacao Alpha',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 1000000.0,
  );

  const candidateB = CandidateSummary(
    id: 102,
    ballotNumber: 22,
    ballotName: 'Candidato Beta',
    fullName: 'Nome Completo Beta',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PL',
    partyName: 'Partido Liberal',
    coalitionName: 'Coligacao Beta',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 2000000.0,
  );

  Widget buildDock({
    required List<CandidateSummary> selectedCandidates,
    ValueChanged<int>? onRemoveCandidate,
    VoidCallback? onClearSelection,
    VoidCallback? onCompare,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: CandidateComparisonDock(
            selectedCandidates: selectedCandidates,
            onRemoveCandidate: onRemoveCandidate ?? (_) {},
            onClearSelection: onClearSelection ?? () {},
            onCompare: onCompare ?? () {},
          ),
        ),
      ),
    );
  }

  group('CandidateComparisonDock - Renderizacao e Acessibilidade', () {
    testWidgets('deve retornar SizedBox.shrink quando lista de selecionados for vazia', (
      tester,
    ) async {
      await tester.pumpWidget(buildDock(selectedCandidates: const []));
      expect(find.byType(CandidateComparisonDock), findsOneWidget);
      expect(find.textContaining('selecionado'), findsNothing);
    });

    testWidgets('deve exibir contador e status desabilitado com apenas 1 candidato', (
      tester,
    ) async {
      await tester.pumpWidget(buildDock(selectedCandidates: const [candidateA]));

      expect(find.text('1 selecionado(s)'), findsOneWidget);
      expect(find.text('Selecione +1'), findsOneWidget);
    });

    testWidgets('deve habilitar botao de comparacao quando houver 2 ou mais candidatos', (
      tester,
    ) async {
      var comparePressed = false;
      await tester.pumpWidget(
        buildDock(
          selectedCandidates: const [candidateA, candidateB],
          onCompare: () => comparePressed = true,
        ),
      );

      expect(find.text('2 selecionado(s)'), findsOneWidget);
      expect(find.text('Comparar (2)'), findsOneWidget);

      await tester.tap(find.text('Comparar (2)'));
      await tester.pump();

      expect(comparePressed, isTrue);
    });

    testWidgets('deve acionar onRemoveCandidate ao clicar no botao de fechar miniatura', (
      tester,
    ) async {
      int? removedId;
      await tester.pumpWidget(
        buildDock(
          selectedCandidates: const [candidateA, candidateB],
          onRemoveCandidate: (id) => removedId = id,
        ),
      );

      // Botao de fechar da miniatura
      final removeButtons = find.byIcon(Icons.close);
      expect(removeButtons, findsWidgets);

      // Clica no primeiro botao de fechar correspondente a miniatura
      await tester.tap(removeButtons.last);
      await tester.pump();

      expect(removedId, isNotNull);
    });

    testWidgets('deve acionar onClearSelection ao clicar no botao limpar', (tester) async {
      var cleared = false;
      await tester.pumpWidget(
        buildDock(
          selectedCandidates: const [candidateA, candidateB],
          onClearSelection: () => cleared = true,
        ),
      );

      final clearButton = find.byTooltip('Limpar seleção');
      expect(clearButton, findsOneWidget);

      await tester.tap(clearButton);
      await tester.pump();

      expect(cleared, isTrue);
    });
  });
}
