import 'package:equatable/equatable.dart';

/// DTO representativo de um cargo disputado em determinada circunscricao eleitoral.
///
/// Mapeia cada elemento da lista `cargos[]` retornada pelo endpoint de cargos do TSE.
class ElectionCargoDto extends Equatable {
  final int code;
  final String sigla;
  final String name;
  final int superiorCode;
  final bool isTitular;
  final int candidateCount;

  const ElectionCargoDto({
    required this.code,
    required this.sigla,
    required this.name,
    required this.superiorCode,
    required this.isTitular,
    required this.candidateCount,
  });

  /// Instancia DTO a partir de mapa JSON com parsing defensivo de nulos e tipos.
  factory ElectionCargoDto.fromJson(Map<String, dynamic> json) {
    return ElectionCargoDto(
      code: (json['codigo'] as num?)?.toInt() ?? 0,
      sigla: json['sigla'] as String? ?? '',
      name: json['nome'] as String? ?? '',
      superiorCode: (json['codSuperior'] as num?)?.toInt() ?? 0,
      isTitular: json['titular'] as bool? ?? true,
      candidateCount: (json['contagem'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converte a instancia em mapa serializavel.
  Map<String, dynamic> toJson() {
    return {
      'codigo': code,
      'sigla': sigla,
      'nome': name,
      'codSuperior': superiorCode,
      'titular': isTitular,
      'contagem': candidateCount,
    };
  }

  @override
  List<Object?> get props => [code, sigla, name, superiorCode, isTitular, candidateCount];
}
