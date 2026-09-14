import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';

/// Ciclo de vida operacional do filtro eleitoral.
enum ElectionFilterStatus { initial, loading, success, failure }

/// Estado imutavel do gerenciador de selecao eleitoral, territorial e de cargo.
class ElectionFilterState extends Equatable {
  final ElectionFilterStatus status;
  final List<Election> elections;
  final Election? selectedElection;
  final List<FederativeUnit> availableUfs;
  final FederativeUnit? selectedUf;
  final List<ElectionRole> availableRoles;
  final ElectionRole? selectedRole;
  final Failure? failure;

  const ElectionFilterState({
    required this.status,
    this.elections = const [],
    this.selectedElection,
    this.availableUfs = const [],
    this.selectedUf,
    this.availableRoles = const [],
    this.selectedRole,
    this.failure,
  });

  /// Estado inicial limpo antes do disparo de carregamento de pleitos.
  factory ElectionFilterState.initial() {
    return const ElectionFilterState(
      status: ElectionFilterStatus.initial,
      availableUfs: FederativeUnit.values,
    );
  }

  /// Construtor de contingencia para falhas de recuperacao de dados.
  factory ElectionFilterState.failure(Failure failure, {ElectionFilterState? previousState}) {
    return ElectionFilterState(
      status: ElectionFilterStatus.failure,
      elections: previousState?.elections ?? const [],
      selectedElection: previousState?.selectedElection,
      availableUfs: previousState?.availableUfs ?? FederativeUnit.values,
      selectedUf: previousState?.selectedUf,
      availableRoles: previousState?.availableRoles ?? const [],
      selectedRole: previousState?.selectedRole,
      failure: failure,
    );
  }

  bool get isLoading => status == ElectionFilterStatus.loading;
  bool get isSuccess => status == ElectionFilterStatus.success;
  bool get isFailure => status == ElectionFilterStatus.failure;

  /// Retorna os parametros normalizados para alimentacao da listagem de candidatos.
  bool get hasValidSelection =>
      selectedElection != null && selectedUf != null && selectedRole != null;

  /// Clona o estado atual com substituicao seletiva de campos.
  ElectionFilterState copyWith({
    ElectionFilterStatus? status,
    List<Election>? elections,
    Election? selectedElection,
    List<FederativeUnit>? availableUfs,
    FederativeUnit? selectedUf,
    List<ElectionRole>? availableRoles,
    ElectionRole? selectedRole,
    Failure? failure,
  }) {
    return ElectionFilterState(
      status: status ?? this.status,
      elections: elections ?? this.elections,
      selectedElection: selectedElection ?? this.selectedElection,
      availableUfs: availableUfs ?? this.availableUfs,
      selectedUf: selectedUf ?? this.selectedUf,
      availableRoles: availableRoles ?? this.availableRoles,
      selectedRole: selectedRole ?? this.selectedRole,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    elections,
    selectedElection,
    availableUfs,
    selectedUf,
    availableRoles,
    selectedRole,
    failure,
  ];
}
