import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/candidate_role_selector_pills.dart';

void main() {
  Widget buildTestWidget({
    required List<ElectionRole> availableRoles,
    required ElectionRole? selectedRole,
    required ValueChanged<ElectionRole> onRoleSelected,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: CandidateRoleSelectorPills(
          availableRoles: availableRoles,
          selectedRole: selectedRole,
          onRoleSelected: onRoleSelected,
        ),
      ),
    );
  }

  group('CandidateRoleSelectorPills - Selecao Horizontal e Acessibilidade', () {
    testWidgets('deve renderizar todos os cargos disponiveis em pills horizontais', (tester) async {
      const roles = [
        ElectionRole.governor,
        ElectionRole.senator,
        ElectionRole.federalDeputy,
        ElectionRole.stateDeputy,
      ];

      await tester.pumpWidget(
        buildTestWidget(
          availableRoles: roles,
          selectedRole: ElectionRole.governor,
          onRoleSelected: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Governador'), findsOneWidget);
      expect(find.text('Senador'), findsOneWidget);
      expect(find.text('Deputado Federal'), findsOneWidget);
      expect(find.text('Deputado Estadual'), findsOneWidget);
    });

    testWidgets('deve disparar callback onRoleSelected ao clicar em cargo nao selecionado', (
      tester,
    ) async {
      ElectionRole? tappedRole;
      const roles = [ElectionRole.governor, ElectionRole.senator];

      await tester.pumpWidget(
        buildTestWidget(
          availableRoles: roles,
          selectedRole: ElectionRole.governor,
          onRoleSelected: (role) => tappedRole = role,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Senador'));
      await tester.pumpAndSettle();

      expect(tappedRole, equals(ElectionRole.senator));
    });

    testWidgets('nao deve disparar callback ao clicar no cargo ja selecionado', (tester) async {
      ElectionRole? tappedRole;
      const roles = [ElectionRole.governor, ElectionRole.senator];

      await tester.pumpWidget(
        buildTestWidget(
          availableRoles: roles,
          selectedRole: ElectionRole.governor,
          onRoleSelected: (role) => tappedRole = role,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Governador'));
      await tester.pumpAndSettle();

      expect(tappedRole, isNull);
    });

    testWidgets('alvo de toque deve possuir dimensao minima de 48dp', (tester) async {
      const roles = [ElectionRole.president];

      await tester.pumpWidget(
        buildTestWidget(
          availableRoles: roles,
          selectedRole: ElectionRole.president,
          onRoleSelected: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      final pillFinder = find.byType(Container).first;
      final size = tester.getSize(pillFinder);
      expect(size.height, greaterThanOrEqualTo(48.0));
      expect(size.width, greaterThanOrEqualTo(48.0));
    });
  });
}
