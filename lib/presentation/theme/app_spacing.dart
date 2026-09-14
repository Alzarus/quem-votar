import 'package:flutter/material.dart';

/// Escala modular de espacamento e dimensoes ergonomicas do design system Quem Votar.
///
/// Baseada em incrementos de 4 e 8 dp, assegurando alinhamento consistente e alvos de toque
/// compativeis com WCAG 2.1 AA (minimo de 48x48 dp), conforme docs/design-system.md.
abstract final class AppSpacing {
  /// Espacamento minimo de 4 dp (space-2xs).
  static const double space2xs = 4.0;

  /// Espacamento de 8 dp (space-xs) - unidade base da grelha.
  static const double spaceXs = 8.0;

  /// Espacamento intermediario de 12 dp (space-sm).
  static const double spaceSm = 12.0;

  /// Margem padrao de telas moveis e cartoes de 16 dp (space-md).
  static const double spaceMd = 16.0;

  /// Espacamento generoso de 24 dp (space-lg).
  static const double spaceLg = 24.0;

  /// Espacamento de respiro amplo de 32 dp (space-xl).
  static const double spaceXl = 32.0;

  /// Espacamento maximo de 48 dp (space-2xl).
  static const double space2xl = 48.0;

  /// EdgeInsets pre-computados para uso eficiente em layouts sem instanciacoes superfluas.
  static const EdgeInsets edgeInsetsXs = EdgeInsets.all(spaceXs);
  static const EdgeInsets edgeInsetsSm = EdgeInsets.all(spaceSm);
  static const EdgeInsets edgeInsetsMd = EdgeInsets.all(spaceMd);
  static const EdgeInsets edgeInsetsLg = EdgeInsets.all(spaceLg);
  static const EdgeInsets edgeInsetsHorizontalMd = EdgeInsets.symmetric(horizontal: spaceMd);
  static const EdgeInsets edgeInsetsVerticalSm = EdgeInsets.symmetric(vertical: spaceSm);
}

/// Dimensoes ergonomicas minimas de toque para componentes interativos.
abstract final class AppTouchTarget {
  /// Alvo de toque minimo de 48x48 dp conforme WCAG 2.1 AA (kMinInteractiveDimension).
  static const double minInteractiveDimension = 48.0;

  /// Restricoes minimas de caixa para botoes, seletores e alvos clicaveis.
  static const BoxConstraints minConstraints = BoxConstraints(
    minWidth: minInteractiveDimension,
    minHeight: minInteractiveDimension,
  );
}
