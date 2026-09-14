import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_detail_assets_section.dart';

void main() {
  const mockAssets = [
    CandidateAsset(
      orderIndex: 1,
      category: 'Apartamento',
      description: 'Apartamento 1002 Residencial',
      amount: 687091.02,
      updatedAt: '2026-08-26',
    ),
  ];

  Widget buildTestWidget({
    required List<CandidateAsset> assets,
    required double totalAmount,
    CandidateAssetSortOption sortOption = CandidateAssetSortOption.descendingValue,
    ValueChanged<CandidateAssetSortOption>? onSortChanged,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: CandidateDetailAssetsSection(
            assets: assets,
            totalAmount: totalAmount,
            activeSortOption: sortOption,
            onSortOptionChanged: onSortChanged,
          ),
        ),
      ),
    );
  }

  testWidgets('deve exibir mensagem quando nao houver bens declarados', (tester) async {
    await tester.pumpWidget(buildTestWidget(assets: const [], totalAmount: 0.0));

    expect(find.text('Patrimonio Declarado'), findsOneWidget);
    expect(find.text('0 itens'), findsOneWidget);
    expect(
      find.text('Nenhum bem patrimonial declarado perante a Justica Eleitoral.'),
      findsOneWidget,
    );
  });

  testWidgets('deve renderizar consolidacao total e itens com valor formatado', (tester) async {
    await tester.pumpWidget(buildTestWidget(assets: mockAssets, totalAmount: 687091.02));

    expect(find.text('Patrimonio Declarado'), findsOneWidget);
    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('Apartamento'), findsOneWidget);
    expect(find.text('Apartamento 1002 Residencial'), findsOneWidget);
    expect(find.text('Total Declarado a Justica Eleitoral'), findsOneWidget);
    expect(find.text('Ordenar por:'), findsOneWidget);
  });
}
