import 'package:flutter/material.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F3D2E)),
      ),
      home: const Scaffold(
        body: Center(child: Text('Quem Votar - Plataforma de Transparencia Eleitoral')),
      ),
    );
  }
}
