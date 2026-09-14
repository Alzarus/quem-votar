import 'package:flutter/material.dart';

/// Escala tipografica acessivel do sistema de design institucional Quem Votar.
///
/// Hierarquia harmoniosa baseada na familia sans-serif contemporanea com pesos
/// e alturas proporcionais que suportam ampliacao dinamica (textScaler),
/// conforme estipulado em docs/design-system.md.
abstract final class AppTypography {
  /// Titulos principais de paginas (28sp, Negrito w700, Altura 1.25).
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.2,
  );

  /// Nome de urna do candidato e cabecalhos de destaque (20sp, Semi-Negrito w600, Altura 1.30).
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.30,
    letterSpacing: -0.1,
  );

  /// Subtitulos de secoes e cargos (16sp, Semi-Negrito w600, Altura 1.35).
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Dados civis e textos corridos principais (16sp, Regular w400, Altura 1.45).
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  /// Listas discriminadas de bens e descricoes auxiliares (14sp, Regular w400, Altura 1.40).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );

  /// Rotulos de botoes e chips de filtro (14sp, Medio w500, Altura 1.20).
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.20,
  );

  /// Metadados e carimbos de data/hora (12sp, Regular w400, Altura 1.20).
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.20,
  );

  /// Fabrica do TextTheme completo do Flutter injetando cores primarias e secundarias.
  static TextTheme buildTextTheme({required Color primaryColor, required Color secondaryColor}) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primaryColor),
      headlineMedium: headlineMedium.copyWith(color: primaryColor),
      titleMedium: titleMedium.copyWith(color: primaryColor),
      bodyLarge: bodyLarge.copyWith(color: primaryColor),
      bodyMedium: bodyMedium.copyWith(color: secondaryColor),
      labelLarge: labelLarge.copyWith(color: primaryColor),
      labelSmall: labelSmall.copyWith(color: secondaryColor),
    );
  }
}
