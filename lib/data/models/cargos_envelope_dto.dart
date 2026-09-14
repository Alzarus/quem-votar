import 'package:equatable/equatable.dart';
import 'package:quem_votar/data/models/election_cargo_dto.dart';

/// DTO envelope para a consulta de cargos disponiveis em um pleito e UF.
///
/// Encapsula metadados da unidade eleitoral e a lista de cargos em disputa.
class CargosEnvelopeDto extends Equatable {
  final String stateCode;
  final String stateName;
  final List<ElectionCargoDto> cargos;

  const CargosEnvelopeDto({required this.stateCode, required this.stateName, required this.cargos});

  /// Converte JSON bruto do endpoint `/cargos` em instancia imutavel de [CargosEnvelopeDto].
  factory CargosEnvelopeDto.fromJson(Map<String, dynamic> json) {
    final rawUe = json['unidadeEleitoralDTO'] as Map<String, dynamic>? ?? {};
    final rawList = json['cargos'] as List<dynamic>? ?? [];

    final parsedCargos = rawList
        .whereType<Map<String, dynamic>>()
        .map(ElectionCargoDto.fromJson)
        .toList(growable: false);

    return CargosEnvelopeDto(
      stateCode: rawUe['sigla'] as String? ?? rawUe['codigo'] as String? ?? '',
      stateName: rawUe['nome'] as String? ?? '',
      cargos: parsedCargos,
    );
  }

  @override
  List<Object?> get props => [stateCode, stateName, cargos];
}
