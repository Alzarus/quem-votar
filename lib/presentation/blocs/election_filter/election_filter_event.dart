import 'package:equatable/equatable.dart';
import 'package:quem_votar/domain/entities/election.dart';
import 'package:quem_votar/domain/entities/election_role.dart';
import 'package:quem_votar/domain/entities/federative_unit.dart';

/// Evento base para o gerenciador de filtros eleitorais.
sealed class ElectionFilterEvent extends Equatable {
  const ElectionFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Evento de inicializacao para recuperar pleitos eleitorais e configurar padroes.
final class ElectionFilterStarted extends ElectionFilterEvent {
  const ElectionFilterStarted();
}

/// Evento de alteracao da eleicao oficial selecionada.
final class ElectionFilterElectionChanged extends ElectionFilterEvent {
  final Election election;

  const ElectionFilterElectionChanged(this.election);

  @override
  List<Object?> get props => [election];
}

/// Evento de alteracao da Unidade Federativa (UF) ou ambito nacional.
final class ElectionFilterUfChanged extends ElectionFilterEvent {
  final FederativeUnit uf;

  const ElectionFilterUfChanged(this.uf);

  @override
  List<Object?> get props => [uf];
}

/// Evento de alteracao do cargo oficial disputado.
final class ElectionFilterRoleChanged extends ElectionFilterEvent {
  final ElectionRole role;

  const ElectionFilterRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}
