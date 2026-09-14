import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CandidateAvatarWidget - Acessibilidade e Fallback', () {
    testWidgets('deve exibir icone de contingencia quando photoUrl for nula', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const CandidateAvatarWidget(candidateName: 'SILVA')),
      );

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('deve exibir icone de contingencia quando photoUrl for vazia', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const CandidateAvatarWidget(candidateName: 'SILVA', photoUrl: '   ')),
      );

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });

    testWidgets('deve conter anotacao Semantics de imagem com nome do candidato', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestableWidget(
          const CandidateAvatarWidget(
            candidateName: 'CIRO GOMES',
            photoUrl: 'https://divulgacandcontas.tse.jus.br/foto.jpg',
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(CandidateAvatarWidget)),
        matchesSemantics(isImage: true, label: 'Foto oficial de urna de CIRO GOMES'),
      );

      handle.dispose();
    });
  });
}
