import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_civil_data.dart';

void main() {
  const mockDetail = CandidateDetail(
    id: 12001,
    ballotNumber: 12,
    ballotName: 'CIRO GOMES',
    fullName: 'CIRO FERREIRA GOMES',
    roleCode: 1,
    roleDescription: 'Presidente',
    partyAcronym: 'PDT',
    partyName: 'Partido Democratico Trabalhista',
    coalitionName: 'PDT',
    photoUrl: 'https://divulgacandcontas.tse.jus.br/ciro.jpg',
    registrationStatus: RegistrationStatus.deferred,
    rawStatusDescription: 'DEFERIDO',
    totalAssetsAmount: 0.0,
    birthDate: '1957-11-06',
    gender: 'MASC.',
    colorRace: 'BRANCA',
    maritalStatus: 'Divorciado(a)',
    educationLevel: 'Superior completo',
    occupation: 'Advogado',
    nationality: 'Brasileira nata',
    birthCity: 'Pindamonhangaba',
    birthState: 'SP',
    maxCampaignExpenseFirstTurn: 88944030.80,
    maxCampaignExpenseSecondTurn: 44472015.40,
    assets: [],
    runningMates: [],
  );

  Widget buildTestWidget(CandidateDetail detail) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(child: CandidateDetailCivilData(candidateDetail: detail)),
      ),
    );
  }

  testWidgets('deve renderizar qualificacao civil e limites de campanha com formatacao', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget(mockDetail));

    expect(find.text('Qualificacao Civil'), findsOneWidget);
    expect(find.text('Advogado'), findsOneWidget);
    expect(find.text('Superior completo'), findsOneWidget);
    expect(find.text('06/11/1957'), findsOneWidget);
    expect(find.text('Divorciado(a)'), findsOneWidget);
    expect(find.text('Pindamonhangaba (SP)'), findsOneWidget);
    expect(find.text('Teto Legal de Gastos de Campanha'), findsOneWidget);
    expect(find.text('1º Turno'), findsOneWidget);
    expect(find.text('2º Turno'), findsOneWidget);
  });
}
