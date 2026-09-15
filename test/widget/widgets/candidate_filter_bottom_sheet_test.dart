import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_filter_bottom_sheet.dart';

void main() {
  Widget buildTestWidget({
    List<String> availableParties = const ['PL', 'PT', 'UNIÃO'],
    Set<String> selectedParties = const {},
    CandidateStatusFilter statusFilter = CandidateStatusFilter.all,
    CandidateAssetsFilter assetsFilter = CandidateAssetsFilter.all,
    ValueChanged<String>? onPartyToggled,
    ValueChanged<CandidateStatusFilter>? onStatusChanged,
    ValueChanged<CandidateAssetsFilter>? onAssetsChanged,
    VoidCallback? onClearAll,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: CandidateFilterBottomSheet(
          availableParties: availableParties,
          selectedParties: selectedParties,
          statusFilter: statusFilter,
          assetsFilter: assetsFilter,
          onPartyToggled: onPartyToggled ?? (_) {},
          onStatusChanged: onStatusChanged ?? (_) {},
          onAssetsChanged: onAssetsChanged ?? (_) {},
          onClearAll: onClearAll ?? () {},
        ),
      ),
    );
  }

  group('CandidateFilterBottomSheet - Configuracao Multicriterio', () {
    testWidgets('deve renderizar opcoes de status juridico, patrimonio e partidos', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Filtros de Candidaturas'), findsOneWidget);
      expect(find.text('Situação Jurídica do Registro'), findsOneWidget);
      expect(find.text('Patrimônio Declarado no TSE'), findsOneWidget);
      expect(find.text('Partido / Federação Partidária'), findsOneWidget);
      expect(find.text('Concluir e Ver Candidaturas'), findsOneWidget);
    });

    testWidgets('deve exibir icone de confirmacao nos chips selecionados e contador no rodape', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          selectedParties: const {'PT', 'PL'},
          statusFilter: CandidateStatusFilter.eligibleOnly,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsAtLeastNWidgets(3));
      expect(find.text('Concluir e Ver Candidaturas (3)'), findsOneWidget);
    });

    testWidgets('deve disparar onStatusChanged ao selecionar chip de status', (tester) async {
      CandidateStatusFilter? updatedStatus;

      await tester.pumpWidget(buildTestWidget(onStatusChanged: (status) => updatedStatus = status));
      await tester.pumpAndSettle();

      await tester.tap(find.text(CandidateStatusFilter.eligibleOnly.label));
      await tester.pumpAndSettle();

      expect(updatedStatus, equals(CandidateStatusFilter.eligibleOnly));
    });

    testWidgets('deve disparar onPartyToggled ao clicar em FilterChip partidario', (tester) async {
      String? toggledParty;

      await tester.pumpWidget(buildTestWidget(onPartyToggled: (party) => toggledParty = party));
      await tester.pumpAndSettle();

      final partyFinder = find.text('PT');
      await tester.ensureVisible(partyFinder);
      await tester.pumpAndSettle();

      await tester.tap(partyFinder);
      await tester.pumpAndSettle();

      expect(toggledParty, equals('PT'));
    });

    testWidgets('deve disparar onAssetsChanged ao selecionar chip de patrimonio', (tester) async {
      CandidateAssetsFilter? updatedAssets;

      await tester.pumpWidget(buildTestWidget(onAssetsChanged: (assets) => updatedAssets = assets));
      await tester.pumpAndSettle();

      final chipFinder = find.text(CandidateAssetsFilter.above1M.label);
      await tester.ensureVisible(chipFinder);
      await tester.pumpAndSettle();

      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      expect(updatedAssets, equals(CandidateAssetsFilter.above1M));
    });

    testWidgets('deve disparar onClearAll ao clicar no botao Limpar', (tester) async {
      var cleared = false;

      await tester.pumpWidget(buildTestWidget(onClearAll: () => cleared = true));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });
  });
}
