import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/network/dio_client_factory.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/datasources/candidate_local_data_source.dart';
import 'package:quem_votar/data/datasources/theme_preferences_data_source.dart';
import 'package:quem_votar/data/datasources/tse_remote_data_source.dart';
import 'package:quem_votar/data/repositories/candidate_repository_impl.dart';
import 'package:quem_votar/data/repositories/election_repository_impl.dart';
import 'package:quem_votar/domain/usecases/get_candidate_detail_use_case.dart';
import 'package:quem_votar/domain/usecases/get_candidates_list_use_case.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/presentation/blocs/candidate_comparison/candidate_comparison_bloc.dart';
import 'package:quem_votar/presentation/blocs/candidate_list/candidate_list_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_bloc.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/blocs/theme/theme_cubit.dart';
import 'package:quem_votar/presentation/pages/candidate_list_page.dart';
import 'package:quem_votar/presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint('[QuemVotar] Inicializando dependencias de producao...');
    final dio = TseDioClientFactory.create();
    final remoteDataSource = TseRemoteDataSourceImpl(dio: dio);
    final database = AppDatabase();
    final localDataSource = CandidateLocalDataSourceImpl(db: database);

    final electionRepository = ElectionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    final candidateRepository = CandidateRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    final getElectionsUseCase = GetElectionsUseCase(electionRepository);
    final getCandidatesListUseCase = GetCandidatesListUseCase(candidateRepository);
    final getCandidateDetailUseCase = GetCandidateDetailUseCase(candidateRepository);

    debugPrint('[QuemVotar] Dependencias configuradas com exito. Iniciando aplicacao...');
    runApp(
      QuemVotarApp(
        getElectionsUseCase: getElectionsUseCase,
        getCandidatesListUseCase: getCandidatesListUseCase,
        getCandidateDetailUseCase: getCandidateDetailUseCase,
      ),
    );
  } catch (e, stack) {
    debugPrint('[QuemVotar ERRO NA INICIALIZACAO] $e\n$stack');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Falha na inicializacao do Quem Votar: $e\n$stack'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ponto de entrada raiz da aplicacao civica Quem Votar.
class QuemVotarApp extends StatelessWidget {
  final Widget? home;
  final GetElectionsUseCase? getElectionsUseCase;
  final GetCandidatesListUseCase? getCandidatesListUseCase;
  final GetCandidateDetailUseCase? getCandidateDetailUseCase;
  final ThemeCubit? themeCubit;
  final ThemePreferencesDataSource? themeDataSource;

  const QuemVotarApp({
    super.key,
    this.home,
    this.getElectionsUseCase,
    this.getCandidatesListUseCase,
    this.getCandidateDetailUseCase,
    this.themeCubit,
    this.themeDataSource,
  });

  @override
  Widget build(BuildContext context) {
    if (themeCubit != null) {
      return BlocProvider<ThemeCubit>.value(value: themeCubit!, child: _buildAppContent());
    }
    return BlocProvider<ThemeCubit>(
      create: (_) =>
          ThemeCubit(dataSource: themeDataSource ?? const SharedPreferencesThemeDataSource()),
      child: _buildAppContent(),
    );
  }

  Widget _buildAppContent() {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Quem Votar',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: _resolveHome(),
        );
      },
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
    final comparisonBloc = getCandidateDetailUseCase != null
        ? CandidateComparisonBloc(getCandidateDetailUseCase: getCandidateDetailUseCase!)
        : null;

    Widget content = CandidateListPage(
      electionFilterBloc: filterBloc,
      candidateListBloc: listBloc,
      candidateComparisonBloc: comparisonBloc,
    );

    if (getCandidateDetailUseCase != null) {
      content = RepositoryProvider<GetCandidateDetailUseCase>.value(
        value: getCandidateDetailUseCase!,
        child: content,
      );
    }

    return content;
  }
}
