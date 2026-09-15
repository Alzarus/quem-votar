import 'package:flutter/material.dart';

/// Paleta de cores primitivas de referencia do sistema de design institucional Quem Votar.
///
/// Baseada em tons neutros sobrios e cores civicas de alta legibilidade,
/// em estrita consonancia com docs/design-system.md e diretrizes WCAG 2.1 AA.
abstract final class AppColors {
  // Primitivos Neutros Harmonizados com o Portal To de Olho
  static const Color slate50 = Color(0xFFF9FAFB);
  static const Color slate100 = Color(0xFFEFF2F5);
  static const Color slate200 = Color(0xFFD9DFE5);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF9EABB8);
  static const Color slate600 = Color(0xFF5B646F);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF17202A);
  static const Color slate900 = Color(0xFF0F171F);
  static const Color slate950 = Color(0xFF050C13);

  // Primitivos Civicos - Azul Institucional Senado / To de Olho
  static const Color civic300 = Color(0xFF60A5FA);
  static const Color civic400 = Color(0xFF0F74C5);
  static const Color civic500 = Color(0xFF0066C0);
  static const Color civic600 = Color(0xFF0056A4);
  static const Color civic700 = Color(0xFF003884);

  // Primitivos Institucionais - Ouro / Ambar Senado / To de Olho
  static const Color gold100 = Color(0xFFFEF3C7);
  static const Color gold300 = Color(0xFFFCD34D);
  static const Color gold500 = Color(0xFFD9A514);
  static const Color gold600 = Color(0xFFC1983A);
  static const Color gold700 = Color(0xFFB98600);
  static const Color gold900 = Color(0xFF78350F);

  // Primitivos de Estado: Deferido / Regular (Verde Civico)
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald600 = Color(0xFF11AD32);
  static const Color emerald700 = Color(0xFF047857);

  // Primitivos de Estado: Aguardando Julgamento / Recurso (Ambar)
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber700 = Color(0xFFB45309);

  // Primitivos de Estado: Indeferido / Cassado (Vermelho Destrutivo)
  static const Color rose400 = Color(0xFFFB7185);
  static const Color rose600 = Color(0xFFD40924);
  static const Color rose700 = Color(0xFFBE123C);

  // Cores Auxiliares
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
