import 'package:equatable/equatable.dart';

/// DTO para transferencia de informacoes de pleitos eleitorais do TSE.
///
/// Mapeia o payload JSON retornado pela rota `/eleicao/ordinarias`.
class ElectionDto extends Equatable {
  final int id;
  final int year;
  final String name;
  final String description;
  final String type;
  final String scope;
  final String electionDate;

  const ElectionDto({
    required this.id,
    required this.year,
    required this.name,
    required this.description,
    required this.type,
    required this.scope,
    required this.electionDate,
  });

  /// Converte mapa JSON em instancia imutavel de [ElectionDto] de modo defensivo.
  factory ElectionDto.fromJson(Map<String, dynamic> json) {
    return ElectionDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      year: (json['ano'] as num?)?.toInt() ?? 0,
      name: json['nomeEleicao'] as String? ?? '',
      description: json['descricaoEleicao'] as String? ?? '',
      type: json['tipoEleicao'] as String? ?? '',
      scope: json['tipoAbrangencia'] as String? ?? '',
      electionDate: json['dataEleicao'] as String? ?? '',
    );
  }

  /// Converte a instancia de DTO em mapa serializavel para persistencia e testes.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ano': year,
      'nomeEleicao': name,
      'descricaoEleicao': description,
      'tipoEleicao': type,
      'tipoAbrangencia': scope,
      'dataEleicao': electionDate,
    };
  }

  @override
  List<Object?> get props => [id, year, name, description, type, scope, electionDate];
}
