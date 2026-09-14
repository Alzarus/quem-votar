import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_proposal_card.dart';

void main() {
  Widget buildTestWidget({String? proposalUrl, VoidCallback? onOpen}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: CandidateDetailProposalCard(proposalDocumentUrl: proposalUrl, onOpenProposal: onOpen),
      ),
    );
  }

  testWidgets('deve exibir mensagem de ausencia quando URL for nula ou vazia', (tester) async {
    await tester.pumpWidget(buildTestWidget(proposalUrl: null));

    expect(find.text('Diretrizes e Plano de Governo'), findsOneWidget);
    expect(
      find.text('Nenhum documento de proposta de governo registrado para esta candidatura.'),
      findsOneWidget,
    );
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('deve exibir botao e acionar callback quando URL estiver disponivel', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      buildTestWidget(
        proposalUrl: 'https://divulgacandcontas.tse.jus.br/proposta.pdf',
        onOpen: () => opened = true,
      ),
    );

    final button = find.text('Acessar Proposta de Governo (PDF)');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();

    expect(opened, isTrue);
  });
}
