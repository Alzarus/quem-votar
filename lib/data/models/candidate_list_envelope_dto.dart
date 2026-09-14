import 'package:equatable/equatable.dart';
import 'package:quem_votar/data/models/candidate_list_item_dto.dart';

/// DTO envelope de resposta para a listagem oficial de candidatos do TSE.
///
/// Encapsula metadados da circunscricao territorial, informacoes do cargo
/// e a relacao sintetizada de candidatos concorrentes.
class CandidateListEnvelopeDto extends Equatable {
  final String stateCode;
  final String stateName;
  final int roleCode;
  final String roleName;
  final List<CandidateListItemDto> candidates;

  const CandidateListEnvelopeDto({
    required this.stateCode,
    required this.stateName,
    required this.roleCode,
    required this.roleName,
    required this.candidates,
  });

  /// Converte mapa JSON da resposta da API em instancia imutavel de [CandidateListEnvelopeDto].
  factory CandidateListEnvelopeDto.fromJson(Map<String, dynamic> json) {
    final ueMap = json['unidadeEleitoral'] as Map<String, dynamic>? ?? {};
    final cargoMap = json['cargo'] as Map<String, dynamic>? ?? {};
    final rawList = json['candidatos'] as List<dynamic>? ?? [];

    final parsedCandidates = rawList
        .whereType<Map<String, dynamic>>()
        .map(CandidateListItemDto.fromJson)
        .toList(growable: false);

    return CandidateListEnvelopeDto(
      stateCode: ueMap['sigla'] as String? ?? '',
      stateName: ueMap['nome'] as String? ?? '',
      roleCode: (cargoMap['codigo'] as num?)?.toInt() ?? 0,
      roleName: cargoMap['nome'] as String? ?? '',
      candidates: parsedCandidates,
    );
  }

  @override
  List<Object?> get props => [stateCode, stateName, roleCode, roleName, candidates];
}
