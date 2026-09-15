import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/widgets/theme_mode_button.dart';

Widget _buildTestWrapper({required Widget child, ThemeMode mode = ThemeMode.system}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: mode,
    home: Scaffold(appBar: AppBar(actions: [child])),
  );
}

void main() {
  group('ThemeModeButton - Acessibilidade WCAG e Selecao de Temas', () {
    testWidgets('deve renderizar icone correspondente ao modo ativo', (tester) async {
      await tester.pumpWidget(
        _buildTestWrapper(child: const ThemeModeButton(currentMode: ThemeMode.system)),
      );

      expect(find.byIcon(Icons.brightness_auto_outlined), findsOneWidget);

      await tester.pumpWidget(
        _buildTestWrapper(child: const ThemeModeButton(currentMode: ThemeMode.light)),
      );

      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

      await tester.pumpWidget(
        _buildTestWrapper(child: const ThemeModeButton(currentMode: ThemeMode.dark)),
      );

      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('deve atender ao alvo minimo de toque de 48dp e conter Semantics', (tester) async {
      await tester.pumpWidget(
        _buildTestWrapper(child: const ThemeModeButton(currentMode: ThemeMode.system)),
      );

      final buttonFinder = find.byType(PopupMenuButton<ThemeMode>);
      expect(buttonFinder, findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(buttonFinder);
      expect(renderBox.size.width, greaterThanOrEqualTo(48.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(48.0));

      expect(
        find.bySemanticsLabel(RegExp(r'Alternar tema de exibicao.*Tema atual.*Acompanhar Sistema')),
        findsOneWidget,
      );
    });

    testWidgets('deve abrir menu de opcoes e despachar selecao ao clicar', (tester) async {
      ThemeMode? selectedMode;

      await tester.pumpWidget(
        _buildTestWrapper(
          child: ThemeModeButton(
            currentMode: ThemeMode.light,
            onSelected: (mode) => selectedMode = mode,
          ),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton<ThemeMode>));
      await tester.pumpAndSettle();

      expect(find.text('Acompanhar Sistema'), findsOneWidget);
      expect(find.text('Modo Claro'), findsOneWidget);
      expect(find.text('Modo Escuro'), findsOneWidget);

      await tester.tap(find.text('Modo Escuro'));
      await tester.pumpAndSettle();

      expect(selectedMode, equals(ThemeMode.dark));
    });
  });
}
