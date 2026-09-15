import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_state.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_filter_toolbar.dart';

void main() {
  const election2026 = Election(
    id: 2040602026,
    year: 2026,
    name: 'Eleição Geral Federal 2026',
    description: '2026',
    type: 'O',
    scope: 'F',
    electionDate: '2026-10-04',
  );

  const election2022 = Election(
    id: 2040602022,
    year: 2022,
    name: 'Eleição Geral Federal 2022',
    description: '2022',
    type: 'O',
    scope: 'F',
    electionDate: '2022-10-02',
  );

  Widget buildTestWidget({
    List<Election> availableElections = const [election2026, election2022],
    Election? selectedElection = election2026,
    ValueChanged<Election>? onElectionChanged,
    FederativeUnit selectedUf = FederativeUnit.br,
    ValueChanged<FederativeUnit>? onUfChanged,
    CandidateSortOption selectedSort = CandidateSortOption.alphabetical,
    ValueChanged<CandidateSortOption>? onSortOptionChanged,
    Size size = const Size(800, 600),
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: CandidateFilterToolbar(
              availableElections: availableElections,
              selectedElection: selectedElection,
              onElectionChanged: onElectionChanged,
              availableUfs: const [FederativeUnit.br, FederativeUnit.sp, FederativeUnit.rj],
              selectedUf: selectedUf,
              onUfChanged: onUfChanged ?? (_) {},
              selectedSortOption: selectedSort,
              onSortOptionChanged: onSortOptionChanged ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('CandidateFilterToolbar - Renderizacao e Semantica', () {
    testWidgets('deve renderizar dropdowns de pleito, territorio e ordenacao no modo amplo', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(size: const Size(800, 600)));
      await tester.pumpAndSettle();

      expect(find.text('Eleição Geral Federal 2026'), findsOneWidget);
      expect(find.text('BR - Brasil'), findsOneWidget);
      expect(find.text('Nome de Urna (A-Z)'), findsOneWidget);
    });

    testWidgets('deve renderizar dropdowns no modo compacto mobile', (tester) async {
      await tester.pumpWidget(buildTestWidget(size: const Size(390, 600)));
      await tester.pumpAndSettle();

      expect(find.text('Eleição Geral Federal 2026'), findsOneWidget);
      expect(find.text('BR - Brasil'), findsOneWidget);
      expect(find.text('Nome de Urna (A-Z)'), findsOneWidget);
    });

    testWidgets('deve acionar onElectionChanged ao selecionar novo pleito', (tester) async {
      Election? changedElection;
      await tester.pumpWidget(
        buildTestWidget(onElectionChanged: (election) => changedElection = election),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Eleição Geral Federal 2026'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Eleição Geral Federal 2022').last);
      await tester.pumpAndSettle();

      expect(changedElection, equals(election2022));
    });

    testWidgets('deve acionar onUfChanged ao selecionar nova UF', (tester) async {
      FederativeUnit? changedUf;
      await tester.pumpWidget(buildTestWidget(onUfChanged: (uf) => changedUf = uf));
      await tester.pumpAndSettle();

      await tester.tap(find.text('BR - Brasil'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('SP - São Paulo').last);
      await tester.pumpAndSettle();

      expect(changedUf, equals(FederativeUnit.sp));
    });

    testWidgets('deve acionar onSortOptionChanged ao alternar criterio de ordenacao', (
      tester,
    ) async {
      CandidateSortOption? changedSort;
      await tester.pumpWidget(buildTestWidget(onSortOptionChanged: (sort) => changedSort = sort));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nome de Urna (A-Z)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Numero Eleitoral').last);
      await tester.pumpAndSettle();

      expect(changedSort, equals(CandidateSortOption.ballotNumber));
    });
  });
}
