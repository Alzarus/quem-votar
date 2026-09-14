import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';
import 'package:quem_votar/domain/usecases/get_elections_use_case.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_event.dart';
import 'package:quem_votar/presentation/blocs/election_filter/election_filter_state.dart';

/// Gerenciador de estado responsavel pela selecao de pleito, territorio e cargo.
///
/// Implementa a selecao padrao obrigatoria (Eleicao Geral 2026 / BR / Presidente)
/// e assegura coerencia territorial segundo as regras da legislacao eleitoral (CF/88).
class ElectionFilterBloc extends Bloc<ElectionFilterEvent, ElectionFilterState> {
  final GetElectionsUseCase _getElectionsUseCase;

  ElectionFilterBloc({required GetElectionsUseCase getElectionsUseCase})
    : _getElectionsUseCase = getElectionsUseCase,
      super(ElectionFilterState.initial()) {
    on<ElectionFilterStarted>(_onStarted);
    on<ElectionFilterElectionChanged>(_onElectionChanged);
    on<ElectionFilterUfChanged>(_onUfChanged);
    on<ElectionFilterRoleChanged>(_onRoleChanged);
  }

  Future<void> _onStarted(ElectionFilterStarted event, Emitter<ElectionFilterState> emit) async {
    emit(state.copyWith(status: ElectionFilterStatus.loading));
    final result = await _getElectionsUseCase.execute();

    if (result.isFailure) {
      final failure =
          result.failureOrNull ??
          const ServerFailure(
            message: 'Falha desconhecida ao obter pleitos eleitorais.',
            operationalContext: 'ElectionFilterBloc._onStarted',
          );
      emit(ElectionFilterState.failure(failure, previousState: state));
      return;
    }

    _emitInitialSuccess(result.successOrNull ?? const [], emit);
  }

  void _emitInitialSuccess(List<Election> elections, Emitter<ElectionFilterState> emit) {
    final defaultElection = _resolveDefaultElection(elections);
    const initialUf = FederativeUnit.br;
    final initialRoles = _resolveRolesForUf(initialUf);

    emit(
      state.copyWith(
        status: ElectionFilterStatus.success,
        elections: elections,
        selectedElection: defaultElection,
        availableUfs: FederativeUnit.allUnits,
        selectedUf: initialUf,
        availableRoles: initialRoles,
        selectedRole: initialRoles.firstOrNull,
      ),
    );
  }

  void _onElectionChanged(ElectionFilterElectionChanged event, Emitter<ElectionFilterState> emit) {
    emit(state.copyWith(selectedElection: event.election));
  }

  void _onUfChanged(ElectionFilterUfChanged event, Emitter<ElectionFilterState> emit) {
    final newRoles = _resolveRolesForUf(event.uf);
    final newSelectedRole = _resolveSelectedRole(state.selectedRole, newRoles);

    emit(
      state.copyWith(selectedUf: event.uf, availableRoles: newRoles, selectedRole: newSelectedRole),
    );
  }

  void _onRoleChanged(ElectionFilterRoleChanged event, Emitter<ElectionFilterState> emit) {
    if (!state.availableRoles.contains(event.role)) {
      return;
    }
    emit(state.copyWith(selectedRole: event.role));
  }

  /// Seleciona o pleito geral de 2026 com fallback gracioso para o primeiro disponivel.
  Election? _resolveDefaultElection(List<Election> elections) {
    if (elections.isEmpty) return null;
    for (final election in elections) {
      if (election.year == 2026) {
        return election;
      }
    }
    return elections.first;
  }

  /// Resolve os cargos disputados conforme a circunscricao eleitoral.
  ///
  /// Conforme o art. 32, § 3º da CF/88, o DF nao possui Deputados Estaduais,
  /// mas sim Deputados Distritais. O ambito nacional restringe-se a Presidente.
  List<ElectionRole> _resolveRolesForUf(FederativeUnit uf) {
    if (uf.isNational) {
      return const [ElectionRole.president];
    }
    if (uf.isFederalDistrict) {
      return const [
        ElectionRole.governor,
        ElectionRole.senator,
        ElectionRole.federalDeputy,
        ElectionRole.districtDeputy,
      ];
    }
    return const [
      ElectionRole.governor,
      ElectionRole.senator,
      ElectionRole.federalDeputy,
      ElectionRole.stateDeputy,
    ];
  }

  /// Preserva o cargo ativo se ainda for elegivel na nova UF, ou adota o primeiro valido.
  ElectionRole? _resolveSelectedRole(ElectionRole? currentRole, List<ElectionRole> availableRoles) {
    if (currentRole != null && availableRoles.contains(currentRole)) {
      return currentRole;
    }
    return availableRoles.firstOrNull;
  }
}
