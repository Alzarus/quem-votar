import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_card.dart';

void main() {
  const candidate = CandidateSummary(
    id: 101,
    ballotNumber: 13,
    ballotName: 'Candidato Teste',
    fullName: 'Nome Completo Teste',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'Coligacao Unida',
    photoUrl: '',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'Deferido',
    totalAssetsAmount: 1500000.0,
  );

  Widget buildWidget({bool isComparing = false, VoidCallback? onCompareToggle}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: CandidateCard(
          candidate: candidate,
          isComparing: isComparing,
          onCompareToggle: onCompareToggle,
        ),
      ),
    );
  }

  group('CandidateCard - Controle de Comparacao e WCAG', () {
    testWidgets('deve renderizar botao de comparacao inativo quando isComparing for false', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(isComparing: false, onCompareToggle: () {}));

      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('deve renderizar icone de selecao ativa quando isComparing for true', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(isComparing: true, onCompareToggle: () {}));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('deve acionar onCompareToggle ao clicar no botao de comparacao', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        buildWidget(isComparing: false, onCompareToggle: () => toggled = true),
      );

      await tester.tap(find.byIcon(Icons.swap_horiz));
      await tester.pump();

      expect(toggled, isTrue);
    });

    testWidgets('deve atender ao alvo minimo de toque de 48dp no botao de comparacao', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(isComparing: false, onCompareToggle: () {}));

      final buttonFinder = find
          .ancestor(of: find.byIcon(Icons.swap_horiz), matching: find.byType(SizedBox))
          .first;

      final size = tester.getSize(buttonFinder);
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });
  });
}
