import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/presentation/blocs/theme/theme_cubit.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Botao acessivel com menu de selecao explicita entre os temas Claro, Escuro e Sistema.
///
/// Atende aos criterios de acessibilidade WCAG 2.1 AA (alvo minimo de 48x48dp) e provê
/// rotulagem semantica via [Semantics] para tecnologias assistivas.
class ThemeModeButton extends StatelessWidget {
  final ThemeMode? currentMode;
  final ValueChanged<ThemeMode>? onSelected;

  const ThemeModeButton({super.key, this.currentMode, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final activeMode = _resolveActiveMode(context);

    return Semantics(
      button: true,
      label: 'Alternar tema de exibicao. Tema atual: ${_labelForMode(activeMode)}',
      child: ConstrainedBox(
        constraints: AppTouchTarget.minConstraints,
        child: PopupMenuButton<ThemeMode>(
          tooltip: 'Selecionar tema visual',
          icon: Icon(_iconForMode(activeMode), color: semantic.textPrimary, size: 22.0),
          color: semantic.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: semantic.borderSubtle),
          ),
          onSelected: (mode) => _handleSelection(context, mode),
          itemBuilder: (context) => _buildMenuItems(activeMode, semantic),
        ),
      ),
    );
  }

  ThemeMode _resolveActiveMode(BuildContext context) {
    if (currentMode != null) {
      return currentMode!;
    }
    try {
      return context.watch<ThemeCubit>().state;
    } catch (_) {
      return ThemeMode.system;
    }
  }

  void _handleSelection(BuildContext context, ThemeMode mode) {
    if (onSelected != null) {
      onSelected!(mode);
      return;
    }
    try {
      context.read<ThemeCubit>().setThemeMode(mode);
    } catch (_) {
      // Sem cubit no contexto em execucao isolada
    }
  }

  List<PopupMenuEntry<ThemeMode>> _buildMenuItems(
    ThemeMode activeMode,
    AppSemanticColors semantic,
  ) {
    return [
      _buildItem(ThemeMode.system, activeMode, semantic),
      _buildItem(ThemeMode.light, activeMode, semantic),
      _buildItem(ThemeMode.dark, activeMode, semantic),
    ];
  }

  PopupMenuItem<ThemeMode> _buildItem(
    ThemeMode mode,
    ThemeMode activeMode,
    AppSemanticColors semantic,
  ) {
    final isSelected = mode == activeMode;

    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(
            _iconForMode(mode),
            size: 20.0,
            color: isSelected ? semantic.brandPrimary : semantic.textSecondary,
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              _labelForMode(mode),
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? semantic.brandPrimary : semantic.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (isSelected) Icon(Icons.check, size: 18.0, color: semantic.brandPrimary),
        ],
      ),
    );
  }

  IconData _iconForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }

  String _labelForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Modo Claro';
      case ThemeMode.dark:
        return 'Modo Escuro';
      case ThemeMode.system:
        return 'Acompanhar Sistema';
    }
  }
}
