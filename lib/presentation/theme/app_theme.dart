import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_colors.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Configuracao centralizada de temas Claro e Escuro da plataforma Quem Votar.
///
/// Habilita Material 3, injeta tokens semanticos via ThemeExtension e assegura
/// contraste compativel com WCAG 2.1 AA em todos os componentes graficos e superfícies.
abstract final class AppTheme {
  /// Tema institucional para ambiente diurno e modo claro.
  static ThemeData get lightTheme {
    const semantic = AppSemanticColors.light;
    final textTheme = AppTypography.buildTextTheme(
      primaryColor: semantic.textPrimary,
      secondaryColor: semantic.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: semantic.surfaceBackground,
      colorScheme: ColorScheme.light(
        primary: semantic.brandPrimary,
        onPrimary: AppColors.white,
        surface: semantic.surfaceBackground,
        onSurface: semantic.textPrimary,
        outline: semantic.borderSubtle,
        error: semantic.statusIneligible,
        onError: AppColors.white,
      ),
      cardTheme: CardThemeData(
        color: semantic.surfaceCard,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: semantic.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(color: semantic.borderSubtle, thickness: 1.0, space: 1.0),
      textTheme: textTheme,
      extensions: const <ThemeExtension<dynamic>>[AppSemanticColors.light],
    );
  }

  /// Tema institucional para ambiente noturno e modo escuro.
  static ThemeData get darkTheme {
    const semantic = AppSemanticColors.dark;
    final textTheme = AppTypography.buildTextTheme(
      primaryColor: semantic.textPrimary,
      secondaryColor: semantic.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: semantic.surfaceBackground,
      colorScheme: ColorScheme.dark(
        primary: semantic.brandPrimary,
        onPrimary: AppColors.slate950,
        surface: semantic.surfaceBackground,
        onSurface: semantic.textPrimary,
        outline: semantic.borderSubtle,
        error: semantic.statusIneligible,
        onError: AppColors.slate950,
      ),
      cardTheme: CardThemeData(
        color: semantic.surfaceCard,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: semantic.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(color: semantic.borderSubtle, thickness: 1.0, space: 1.0),
      textTheme: textTheme,
      extensions: const <ThemeExtension<dynamic>>[AppSemanticColors.dark],
    );
  }
}
