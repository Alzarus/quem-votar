import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_colors.dart';

/// Tokens semanticos do sistema de design Quem Votar, implementados via ThemeExtension.
///
/// Garante contraste certificado WCAG 2.1 AA e papeis conceituais independentes
/// do modo de cor (claro ou escuro), conforme docs/design-system.md.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.surfaceBackground,
    required this.surfaceCard,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderSubtle,
    required this.brandPrimary,
    required this.statusDeferred,
    required this.statusPending,
    required this.statusIneligible,
  });

  final Color surfaceBackground;
  final Color surfaceCard;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderSubtle;
  final Color brandPrimary;
  final Color statusDeferred;
  final Color statusPending;
  final Color statusIneligible;

  /// Conjunto semantico para modo claro (Light Mode).
  static const AppSemanticColors light = AppSemanticColors(
    surfaceBackground: AppColors.slate50,
    surfaceCard: AppColors.white,
    textPrimary: AppColors.slate900,
    textSecondary: AppColors.slate600,
    borderSubtle: AppColors.slate200,
    brandPrimary: AppColors.civic600,
    statusDeferred: AppColors.emerald700,
    statusPending: AppColors.amber700,
    statusIneligible: AppColors.rose700,
  );

  /// Conjunto semantico para modo escuro (Dark Mode).
  static const AppSemanticColors dark = AppSemanticColors(
    surfaceBackground: AppColors.slate900,
    surfaceCard: AppColors.slate800,
    textPrimary: AppColors.slate50,
    textSecondary: AppColors.slate400,
    borderSubtle: AppColors.slate700,
    brandPrimary: AppColors.civic300,
    statusDeferred: AppColors.emerald400,
    statusPending: AppColors.amber400,
    statusIneligible: AppColors.rose400,
  );

  @override
  AppSemanticColors copyWith({
    Color? surfaceBackground,
    Color? surfaceCard,
    Color? textPrimary,
    Color? textSecondary,
    Color? borderSubtle,
    Color? brandPrimary,
    Color? statusDeferred,
    Color? statusPending,
    Color? statusIneligible,
  }) {
    return AppSemanticColors(
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      statusDeferred: statusDeferred ?? this.statusDeferred,
      statusPending: statusPending ?? this.statusPending,
      statusIneligible: statusIneligible ?? this.statusIneligible,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) {
      return this;
    }
    return AppSemanticColors(
      surfaceBackground: Color.lerp(surfaceBackground, other.surfaceBackground, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      statusDeferred: Color.lerp(statusDeferred, other.statusDeferred, t)!,
      statusPending: Color.lerp(statusPending, other.statusPending, t)!,
      statusIneligible: Color.lerp(statusIneligible, other.statusIneligible, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSemanticColors &&
        other.surfaceBackground == surfaceBackground &&
        other.surfaceCard == surfaceCard &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary &&
        other.borderSubtle == borderSubtle &&
        other.brandPrimary == brandPrimary &&
        other.statusDeferred == statusDeferred &&
        other.statusPending == statusPending &&
        other.statusIneligible == statusIneligible;
  }

  @override
  int get hashCode => Object.hash(
    surfaceBackground,
    surfaceCard,
    textPrimary,
    textSecondary,
    borderSubtle,
    brandPrimary,
    statusDeferred,
    statusPending,
    statusIneligible,
  );
}

/// Extensao de conveniencia sobre BuildContext para acesso rapido aos tokens semanticos.
extension AppSemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}
