import 'package:flutter_test/flutter_test.dart';

import 'package:quem_votar/main.dart';

void main() {
  testWidgets('Smoke test de inicializacao da aplicacao Quem Votar', (WidgetTester tester) async {
    await tester.pumpWidget(const QuemVotarApp());

    expect(find.text('Quem Votar - Plataforma de Transparencia Eleitoral'), findsOneWidget);
  });
}
