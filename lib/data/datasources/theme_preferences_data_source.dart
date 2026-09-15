import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrato para persistencia e recuperacao da preferencia de tema do usuario.
///
/// Permite isolamento da implementacao do armazenamento local para testes unitarios headless.
abstract interface class ThemePreferencesDataSource {
  /// Recupera o modo de tema persistido. Retorna [ThemeMode.system] caso nao haja valor previo.
  Future<ThemeMode> getThemeMode();

  /// Persiste a preferencia de modo de tema do usuario.
  Future<void> saveThemeMode(ThemeMode mode);
}

/// Implementacao baseada em [SharedPreferences] para operacao multiplataforma.
class SharedPreferencesThemeDataSource implements ThemePreferencesDataSource {
  static const String _storageKey = 'quem_votar_theme_mode';
  final SharedPreferences? _prefsInstance;

  const SharedPreferencesThemeDataSource({SharedPreferences? prefs}) : _prefsInstance = prefs;

  Future<SharedPreferences> _getPrefs() async {
    if (_prefsInstance != null) {
      return _prefsInstance;
    }
    return SharedPreferences.getInstance();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString(_storageKey);
      return _parseThemeMode(raw);
    } catch (_) {
      return ThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_storageKey, _serializeThemeMode(mode));
  }

  ThemeMode _parseThemeMode(String? raw) {
    if (raw == null) {
      return ThemeMode.system;
    }
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
