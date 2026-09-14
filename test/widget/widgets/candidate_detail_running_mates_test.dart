import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/running_mate.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_running_mates.dart';

void main() {
  const mockRunningMates = [
    RunningMate(
      id: 12002,
      parentCandidateId: 12001,
      ballotNumber: 12,
      ballotName: 'ANA PAULA',
      fullName: 'ANA PAULA ANDRADE MATOS',
      partyAcronym: 'PDT',
      partyName: 'Partido Democratico Trabalhista',
      roleDescription: 'Vice-presidente',
      photoUrl: 'https://divulgacandcontas.tse.jus.br/vice.jpg',
      isEligible: true,
    ),
  ];

  Widget buildTestWidget(List<RunningMate> mates) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(child: CandidateDetailRunningMates(runningMates: mates)),
      ),
    );
  }

  testWidgets('deve retornar SizedBox.shrink quando lista de suplentes for vazia', (tester) async {
    await tester.pumpWidget(buildTestWidget(const []));

    expect(find.byType(CandidateDetailRunningMates), findsOneWidget);
    expect(find.text('Chapa Majoritaria e Suplencias'), findsNothing);
  });

  testWidgets('deve renderizar chapa majoritaria com nome, cargo e indicador de aptidao', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(mockRunningMates));

    expect(find.text('Chapa Majoritaria e Suplencias'), findsOneWidget);
    expect(find.text('ANA PAULA'), findsOneWidget);
    expect(find.text('Vice-presidente • PDT'), findsOneWidget);
    expect(find.text('Apto'), findsOneWidget);
    expect(find.byType(CandidateAvatarWidget), findsOneWidget);
  });
}
