import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/pages/candidate_list_page.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';

void main() {
  runApp(const QuemVotarApp());
}

/// Ponto de entrada raiz da aplicacao civica Quem Votar.
class QuemVotarApp extends StatelessWidget {
  final Widget? home;
  final GetElectionsUseCase? getElectionsUseCase;
  final GetCandidatesListUseCase? getCandidatesListUseCase;
  final GetCandidateDetailUseCase? getCandidateDetailUseCase;

  const QuemVotarApp({
    super.key,
    this.home,
    this.getElectionsUseCase,
    this.getCandidatesListUseCase,
    this.getCandidateDetailUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quem Votar',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _resolveHome(),
    );
  }

  Widget _resolveHome() {
    if (home != null) {
      return home!;
    }
    if (getElectionsUseCase != null && getCandidatesListUseCase != null) {
      return _buildConfiguredApp();
    }
    return const Scaffold(
      body: Center(child: Text('Quem Votar - Plataforma de Transparencia Eleitoral')),
    );
  }

  Widget _buildConfiguredApp() {
    final filterBloc = ElectionFilterBloc(getElectionsUseCase: getElectionsUseCase!)
      ..add(const ElectionFilterStarted());
    final listBloc = CandidateListBloc(getCandidatesListUseCase: getCandidatesListUseCase!);

    Widget content = CandidateListPage(electionFilterBloc: filterBloc, candidateListBloc: listBloc);

    if (getCandidateDetailUseCase != null) {
      content = RepositoryProvider<GetCandidateDetailUseCase>.value(
        value: getCandidateDetailUseCase!,
        child: content,
      );
    }

    return content;
  }
}
