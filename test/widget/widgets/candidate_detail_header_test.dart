import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/domain/entities/registration_status.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_avatar_widget.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_header.dart';
import 'package:quem_votar/presentation/widgets/candidate_party_chip.dart';
import 'package:quem_votar/presentation/widgets/candidate_status_badge.dart';

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
    rawStatusDescription: 'Deferido pelo TSE sem pendencias',
    totalAssetsAmount: 792091.02,
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
      home: Scaffold(body: CandidateDetailHeader(candidateDetail: detail)),
    );
  }

  testWidgets('deve renderizar dados de identificacao e status da candidatura', (tester) async {
    await tester.pumpWidget(buildTestWidget(mockDetail));

    expect(find.text('CIRO GOMES'), findsOneWidget);
    expect(find.text('CIRO FERREIRA GOMES'), findsOneWidget);
    expect(find.text('Presidente'), findsOneWidget);
    expect(find.text('Deferido pelo TSE sem pendencias'), findsOneWidget);
    expect(find.byType(CandidateAvatarWidget), findsOneWidget);
    expect(find.byType(CandidatePartyChip), findsOneWidget);
    expect(find.byType(CandidateStatusBadge), findsOneWidget);
  });
}
