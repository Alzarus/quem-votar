import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';

void main() {
  runApp(const QuemVotarApp());
}

/// Ponto de entrada raiz da aplicacao civica Quem Votar.
class QuemVotarApp extends StatelessWidget {
  const QuemVotarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quem Votar',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(child: Text('Quem Votar - Plataforma de Transparencia Eleitoral')),
      ),
    );
  }
}
