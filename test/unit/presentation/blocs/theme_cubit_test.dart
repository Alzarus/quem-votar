import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/datasources/theme_preferences_data_source.dart';
import 'package:quem_votar/presentation/blocs/theme/theme_cubit.dart';

class FakeThemePreferencesDataSource implements ThemePreferencesDataSource {
  ThemeMode mode;
  int saveCount = 0;

  FakeThemePreferencesDataSource({this.mode = ThemeMode.system});

  @override
  Future<ThemeMode> getThemeMode() async => mode;

  @override
  Future<void> saveThemeMode(ThemeMode newMode) async {
    mode = newMode;
    saveCount++;
  }
}

void main() {
  group('ThemeCubit - Gerenciamento de Estado e Ciclo de Vida', () {
    test('deve inicializar com ThemeMode.system por padrao', () async {
      final fakeDataSource = FakeThemePreferencesDataSource();
      final cubit = ThemeCubit(dataSource: fakeDataSource);

      expect(cubit.state, equals(ThemeMode.system));
      await cubit.close();
    });

    test('deve carregar tema persistido na inicializacao', () async {
      final fakeDataSource = FakeThemePreferencesDataSource(mode: ThemeMode.dark);
      final cubit = ThemeCubit(dataSource: fakeDataSource);

      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, equals(ThemeMode.dark));
      await cubit.close();
    });

    test('deve atualizar e persistir modo de tema ao chamar setThemeMode', () async {
      final fakeDataSource = FakeThemePreferencesDataSource();
      final cubit = ThemeCubit(dataSource: fakeDataSource);

      await cubit.setThemeMode(ThemeMode.light);

      expect(cubit.state, equals(ThemeMode.light));
      expect(fakeDataSource.mode, equals(ThemeMode.light));
      expect(fakeDataSource.saveCount, equals(1));

      // Nao deve duplicar persistencia se modo for identico
      await cubit.setThemeMode(ThemeMode.light);
      expect(fakeDataSource.saveCount, equals(1));

      await cubit.close();
    });

    test('deve ciclar ordenadamente entre Sistema, Claro e Escuro', () async {
      final fakeDataSource = FakeThemePreferencesDataSource(mode: ThemeMode.system);
      final cubit = ThemeCubit(dataSource: fakeDataSource);

      expect(cubit.state, equals(ThemeMode.system));

      await cubit.cycleThemeMode();
      expect(cubit.state, equals(ThemeMode.light));

      await cubit.cycleThemeMode();
      expect(cubit.state, equals(ThemeMode.dark));

      await cubit.cycleThemeMode();
      expect(cubit.state, equals(ThemeMode.system));

      await cubit.close();
    });
  });
}
