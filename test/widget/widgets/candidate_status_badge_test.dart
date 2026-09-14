import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_status_badge.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CandidateStatusBadge - Situacao Juridica e Semantica', () {
    testWidgets('deve renderizar status Deferido com rotulacao textual e Semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(const CandidateStatusBadge(status: RegistrationStatus.deferred)),
      );

      expect(find.text('Deferido'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(CandidateStatusBadge)),
        matchesSemantics(
          label: 'Situacao do registro: Registro deferido e regular perante a Justiça Eleitoral',
        ),
      );

      handle.dispose();
    });

    testWidgets('deve renderizar status Indeferido com Semantics', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(const CandidateStatusBadge(status: RegistrationStatus.ineligible)),
      );

      expect(find.text('Indeferido'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(CandidateStatusBadge)),
        matchesSemantics(label: 'Situacao do registro: Registro indeferido pela Justiça Eleitoral'),
      );

      handle.dispose();
    });

    testWidgets('deve renderizar status Aguardando Julgamento', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const CandidateStatusBadge(status: RegistrationStatus.waitingJudgment)),
      );

      expect(find.text('Aguardando Julgamento'), findsOneWidget);
    });
  });
}
