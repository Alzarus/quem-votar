import 'package:equatable/equatable.dart';

/// Pleito eleitoral oficial registrado na Justica Eleitoral brasileira.
///
/// Encapsula dados de eleicoes ordinarias ou suplementares obtidas
/// a partir dos servicos oficiais do TSE.
class Election extends Equatable {
  final int id;
  final int year;
  final String name;
  final String description;
  final String type;
  final String scope;
  final String electionDate;

  const Election({
    required this.id,
    required this.year,
    required this.name,
    required this.description,
    required this.type,
    required this.scope,
    required this.electionDate,
  });

  @override
  List<Object?> get props => [id, year, name, description, type, scope, electionDate];
}
