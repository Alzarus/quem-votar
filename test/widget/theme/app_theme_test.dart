import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/presentation/theme/app_colors.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

void main() {
  group('AppTheme - Temas Claro e Escuro', () {
    test('lightTheme deve configurar Material 3 e AppSemanticColors.light', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.light));
      final extension = theme.extension<AppSemanticColors>();
      expect(extension, isNotNull);
      expect(extension, equals(AppSemanticColors.light));
    });

    test('darkTheme deve configurar Material 3 e AppSemanticColors.dark', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.dark));
      final extension = theme.extension<AppSemanticColors>();
      expect(extension, isNotNull);
      expect(extension, equals(AppSemanticColors.dark));
    });
  });

  group('AppSemanticColors - Extensao e Interpolacao', () {
    test('deve suportar copyWith e comparacao por valor', () {
      const original = AppSemanticColors.light;
      final modified = original.copyWith(surfaceBackground: AppColors.white);
      expect(modified.surfaceBackground, equals(AppColors.white));
      expect(modified.surfaceCard, equals(original.surfaceCard));
      expect(original == modified, isFalse);
    });

    test('lerp deve interpolar adequadamente entre temas', () {
      const light = AppSemanticColors.light;
      const dark = AppSemanticColors.dark;
      final interpolated = light.lerp(dark, 0.5);
      expect(interpolated, isNotNull);
      expect(interpolated.surfaceBackground, isNot(equals(light.surfaceBackground)));
      expect(interpolated.surfaceBackground, isNot(equals(dark.surfaceBackground)));
    });

    testWidgets('context.semanticColors deve resolver a partir do Theme ativo', (tester) async {
      late AppSemanticColors resolved;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) {
              resolved = context.semanticColors;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved, equals(AppSemanticColors.light));
    });
  });

  group('AppSpacing e AppTypography - Dimensoes e Tipografia', () {
    test('AppTouchTarget deve garantir alvo minimo de 48dp', () {
      expect(AppTouchTarget.minInteractiveDimension, equals(48.0));
      expect(AppTouchTarget.minConstraints.minWidth, equals(48.0));
      expect(AppTouchTarget.minConstraints.minHeight, equals(48.0));
    });

    test('AppTypography deve construir TextTheme completo', () {
      final textTheme = AppTypography.buildTextTheme(
        primaryColor: AppColors.slate900,
        secondaryColor: AppColors.slate600,
      );
      expect(textTheme.displayLarge?.fontSize, equals(28.0));
      expect(textTheme.headlineMedium?.fontSize, equals(20.0));
      expect(textTheme.titleMedium?.fontSize, equals(16.0));
      expect(textTheme.bodyLarge?.fontSize, equals(16.0));
    });
  });
}
