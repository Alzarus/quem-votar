import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_summary.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_card.dart';

void main() {
  const candidate = CandidateSummary(
    id: 280001607820,
    ballotNumber: 13,
    ballotName: 'LULA',
    fullName: 'LUIZ INACIO LULA DA SILVA',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PT',
    partyName: 'Partido dos Trabalhadores',
    coalitionName: 'BRASIL DA ESPERANCA',
    photoUrl: 'https://divulgacandcontas.tse.jus.br/foto.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'DEFERIDO',
    totalAssetsAmount: 7423725.78,
  );

  Widget buildTestableWidget(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          ),
        ),
      ),
    );
  }

  group('CandidateCard - Renderizacao, Acessibilidade e textScaler', () {
    testWidgets('deve renderizar informacoes essenciais do candidato com fidelidade', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(const CandidateCard(candidate: candidate)));

      expect(find.text('LULA'), findsOneWidget);
      expect(find.text('LUIZ INACIO LULA DA SILVA'), findsOneWidget);
      expect(find.text('PT - 13'), findsOneWidget);
      expect(find.text('Deferido'), findsOneWidget);
      expect(find.textContaining('7.423.725,78'), findsOneWidget);
    });

    testWidgets('deve acionar callback de clique quando fornecido', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(CandidateCard(candidate: candidate, onTap: () => tapped = true)),
      );

      await tester.tap(find.byType(CandidateCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('deve suportar escala de texto ampliada (2.0x) sem estouro de layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CandidateCard(candidate: candidate),
          textScaler: const TextScaler.linear(2.0),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('LULA'), findsOneWidget);
    });

    testWidgets('deve expor rotulacao semantica rica para leitores de tela', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(CandidateCard(candidate: candidate, onTap: () {})),
      );

      final semantics = tester.getSemantics(find.byType(CandidateCard));
      expect(semantics.label.contains('LULA'), isTrue);
      expect(semantics.label.contains('PT'), isTrue);
      expect(semantics.label.contains('13'), isTrue);
      expect(semantics.label.contains('7.423.725,78'), isTrue);
      expect(semantics.label.contains('Tocar para ver detalhes cadastrais.'), isTrue);

      handle.dispose();
    });

    testWidgets('deve exibir mensagem orientativa quando bens declarados forem nulos na listagem', (
      tester,
    ) async {
      const candidateWithoutAssets = CandidateSummary(
        id: 280001607821,
        ballotNumber: 13,
        ballotName: 'LULA',
        fullName: 'LUIZ INACIO LULA DA SILVA',
        roleCode: 1,
        roleDescription: 'Presidente',
        partyAcronym: 'PT',
        partyName: 'Partido dos Trabalhadores',
        coalitionName: 'BRASIL DA ESPERANCA',
        photoUrl: 'https://divulgacandcontas.tse.jus.br/foto.jpg',
        registrationStatus: RegistrationStatus.deferred,
        rawStatusDescription: 'DEFERIDO',
        totalAssetsAmount: null,
      );

      await tester.pumpWidget(
        buildTestableWidget(const CandidateCard(candidate: candidateWithoutAssets)),
      );

      expect(find.text('Bens: Consultar na ficha'), findsOneWidget);
    });
  });
}
