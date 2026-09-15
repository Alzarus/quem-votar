import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_active_filter_bar.dart';

void main() {
  Widget buildTestWidget({
    String searchQuery = '',
    String? selectedParty,
    CandidateStatusFilter statusFilter = CandidateStatusFilter.all,
    CandidateAssetsFilter assetsFilter = CandidateAssetsFilter.all,
    VoidCallback? onClearQuery,
    VoidCallback? onClearParty,
    VoidCallback? onClearStatus,
    VoidCallback? onClearAssets,
    VoidCallback? onClearAll,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: CandidateActiveFilterBar(
          searchQuery: searchQuery,
          selectedParty: selectedParty,
          statusFilter: statusFilter,
          assetsFilter: assetsFilter,
          onClearQuery: onClearQuery ?? () {},
          onClearParty: onClearParty ?? () {},
          onClearStatus: onClearStatus ?? () {},
          onClearAssets: onClearAssets ?? () {},
          onClearAll: onClearAll ?? () {},
        ),
      ),
    );
  }

  group('CandidateActiveFilterBar - Exibicao e Remocao de Filtros', () {
    testWidgets('nao deve renderizar nada quando nenhum filtro estiver ativo', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Wrap), findsNothing);
      expect(find.text('Limpar todos'), findsNothing);
    });

    testWidgets('deve renderizar chips para filtros ativos e botao limpar todos', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          searchQuery: 'lula',
          selectedParty: 'PT',
          statusFilter: CandidateStatusFilter.eligibleOnly,
          assetsFilter: CandidateAssetsFilter.above1M,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Busca: "lula"'), findsOneWidget);
      expect(find.text('Partido: PT'), findsOneWidget);
      expect(find.text(CandidateStatusFilter.eligibleOnly.label), findsOneWidget);
      expect(find.text(CandidateAssetsFilter.above1M.label), findsOneWidget);
      expect(find.text('Limpar todos'), findsOneWidget);
    });

    testWidgets('deve acionar callbacks especificos ao clicar no icone de fechar do chip', (
      tester,
    ) async {
      var clearedParty = false;
      var clearedAll = false;

      await tester.pumpWidget(
        buildTestWidget(
          selectedParty: 'PL',
          onClearParty: () => clearedParty = true,
          onClearAll: () => clearedAll = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(clearedParty, isTrue);

      await tester.tap(find.text('Limpar todos'));
      await tester.pumpAndSettle();
      expect(clearedAll, isTrue);
    });
  });
}
