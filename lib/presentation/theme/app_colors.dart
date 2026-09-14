import 'package:flutter/material.dart';

/// Paleta de cores primitivas de referencia do sistema de design institucional Quem Votar.
///
/// Baseada em tons neutros sobrios e cores civicas de alta legibilidade,
/// em estrita consonancia com docs/design-system.md e diretrizes WCAG 2.1 AA.
abstract final class AppColors {
  // Primitivos Neutros (Slate)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // Primitivos Civicos (Azul Institucional Sobrio)
  static const Color civic300 = Color(0xFF93C5FD);
  static const Color civic500 = Color(0xFF1D4ED8);
  static const Color civic600 = Color(0xFF1E40AF);
  static const Color civic700 = Color(0xFF1E3A8A);

  // Primitivos de Estado: Deferido / Regular (Emerald)
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald700 = Color(0xFF047857);

  // Primitivos de Estado: Aguardando Julgamento / Recurso (Amber)
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber700 = Color(0xFFB45309);

  // Primitivos de Estado: Indeferido / Cassado (Rose)
  static const Color rose400 = Color(0xFFFB7185);
  static const Color rose700 = Color(0xFFBE123C);

  // Cores Auxiliares
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
