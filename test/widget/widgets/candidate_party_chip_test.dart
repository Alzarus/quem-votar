import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_party_chip.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CandidatePartyChip - Legenda Partidaria e Ergonomia', () {
    testWidgets('deve renderizar sigla e numero de urna em modo estatico', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(
          const CandidatePartyChip(
            partyAcronym: 'PT',
            candidateNumber: 13,
            coalition: 'BRASIL DA ESPERANÇA',
          ),
        ),
      );

      expect(find.text('PT - 13'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(CandidatePartyChip)),
        matchesSemantics(label: 'Partido PT, número de urna 13, coligação BRASIL DA ESPERANÇA'),
      );

      handle.dispose();
    });

    testWidgets('deve respeitar alvo minimo de 48dp e acionar callback quando clicavel', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          CandidatePartyChip(partyAcronym: 'PL', candidateNumber: 22, onTap: () => tapped = true),
        ),
      );

      final renderBox = tester.renderObject<RenderBox>(find.byType(CandidatePartyChip));
      expect(renderBox.size.width >= 48.0, isTrue);
      expect(renderBox.size.height >= 48.0, isTrue);

      await tester.tap(find.byType(CandidatePartyChip));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
