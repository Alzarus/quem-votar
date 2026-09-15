import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/data/datasources/theme_preferences_data_source.dart';

/// Gerenciador de estado reativo para alternancia e persistencia do modo de tema da aplicacao.
///
/// Encapsula a logica de selecao entre os modos Claro, Escuro e Sistema, garantindo
/// atualizacao atomica da interface e sincronizacao com a camada de persistencia.
class ThemeCubit extends Cubit<ThemeMode> {
  final ThemePreferencesDataSource _dataSource;
  bool _hasUserSelection = false;

  ThemeCubit({
    required ThemePreferencesDataSource dataSource,
    ThemeMode initialMode = ThemeMode.system,
  }) : _dataSource = dataSource,
       super(initialMode) {
    loadPersistedTheme();
  }

  /// Recupera a configuracao persistida caso o usuario ainda nao tenha efetuado selecao explicita.
  Future<void> loadPersistedTheme() async {
    final mode = await _dataSource.getThemeMode();
    if (!isClosed && !_hasUserSelection && mode != state) {
      emit(mode);
    }
  }

  /// Define e persiste de forma assincrona o modo de tema selecionado pelo usuario.
  Future<void> setThemeMode(ThemeMode mode) async {
    _hasUserSelection = true;
    if (state == mode) {
      return;
    }
    emit(mode);
    await _dataSource.saveThemeMode(mode);
  }

  /// Alterna sequencialmente o modo de aparencia: Sistema -> Claro -> Escuro -> Sistema.
  Future<void> cycleThemeMode() async {
    final nextMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(nextMode);
  }
}
