import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_proposal_modal.dart';

class FakeModalUrlLauncherService implements UrlLauncherService {
  String? openedUrl;
  bool shouldSucceed = true;

  @override
  Future<bool> launchCandidateUrl(String rawUrl) async {
    openedUrl = rawUrl;
    return shouldSucceed;
  }
}

Widget _buildModalWrapper({required Widget child}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: Scaffold(body: child),
  );
}

void main() {
  group('CandidateProposalModal - Usabilidade PWA e Acessibilidade WCAG', () {
    testWidgets('deve renderizar informacoes da candidatura e botao de fechar', (tester) async {
      final fakeLauncher = FakeModalUrlLauncherService();

      await tester.pumpWidget(
        _buildModalWrapper(
          child: CandidateProposalModal(
            candidateName: 'CIRO GOMES',
            proposalUrl: 'https://divulgacandcontas.tse.jus.br/proposta.pdf',
            urlLauncherService: fakeLauncher,
          ),
        ),
      );

      expect(find.text('Diretrizes e Plano de Governo'), findsOneWidget);
      expect(find.text('Candidatura: CIRO GOMES'), findsOneWidget);

      final closeButton = find.bySemanticsLabel('Fechar visualizador de proposta de governo');
      expect(closeButton, findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(closeButton);
      expect(renderBox.size.width, greaterThanOrEqualTo(48.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('deve acionar urlLauncherService ao tocar em Abrir Documento PDF', (tester) async {
      final fakeLauncher = FakeModalUrlLauncherService();
      const testUrl = 'https://divulgacandcontas.tse.jus.br/proposta.pdf';

      await tester.pumpWidget(
        _buildModalWrapper(
          child: CandidateProposalModal(
            candidateName: 'CIRO GOMES',
            proposalUrl: testUrl,
            urlLauncherService: fakeLauncher,
          ),
        ),
      );

      final openButton = find.text('Abrir Documento PDF (Nova Janela)');
      expect(openButton, findsOneWidget);

      await tester.tap(openButton);
      await tester.pump();

      expect(fakeLauncher.openedUrl, equals(testUrl));
    });

    testWidgets('deve copiar link para a area de transferencia ao tocar no botao de copiar', (
      tester,
    ) async {
      final fakeLauncher = FakeModalUrlLauncherService();
      const testUrl = 'https://divulgacandcontas.tse.jus.br/proposta.pdf';
      String? copiedUrl;

      await tester.pumpWidget(
        _buildModalWrapper(
          child: CandidateProposalModal(
            candidateName: 'CIRO GOMES',
            proposalUrl: testUrl,
            urlLauncherService: fakeLauncher,
            onCopy: (url) async => copiedUrl = url,
          ),
        ),
      );

      final copyButton = find.text('Copiar Link da Proposta');
      expect(copyButton, findsOneWidget);

      await tester.tap(copyButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      expect(copiedUrl, equals(testUrl));
      expect(find.text('Link da proposta copiado para a area de transferencia.'), findsOneWidget);
    });
  });
}
