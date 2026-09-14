import 'package:equatable/equatable.dart';

/// DTO representativo de um bem patrimonial declarado pelo candidato.
///
/// Mapeia os elementos do array `bens[]` presentes na ficha detalhada da candidatura.
class CandidateAssetDto extends Equatable {
  final int orderIndex;
  final String category;
  final String description;
  final double amount;
  final String updatedAt;

  const CandidateAssetDto({
    required this.orderIndex,
    required this.category,
    required this.description,
    required this.amount,
    required this.updatedAt,
  });

  /// Instancia DTO com conversao defensiva para campos numericos e textuais.
  factory CandidateAssetDto.fromJson(Map<String, dynamic> json) {
    return CandidateAssetDto(
      orderIndex: (json['ordem'] as num?)?.toInt() ?? 0,
      category: json['descricaoDeTipoDeBem'] as String? ?? '',
      description: json['descricao'] as String? ?? '',
      amount: _parseAmount(json['valor']),
      updatedAt: json['dataUltimaAtualizacao'] as String? ?? '',
    );
  }

  /// Converte a instancia em mapa serializavel.
  Map<String, dynamic> toJson() {
    return {
      'ordem': orderIndex,
      'descricaoDeTipoDeBem': category,
      'descricao': description,
      'valor': amount,
      'dataUltimaAtualizacao': updatedAt,
    };
  }

  /// Extrai valor monetario com suporte tanto a tipos numericos quanto strings formatadas.
  static double _parseAmount(Object? raw) {
    if (raw == null) return 0.0;
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final sanitized = raw.trim().replaceAll(',', '.');
      return double.tryParse(sanitized) ?? 0.0;
    }
    return 0.0;
  }

  @override
  List<Object?> get props => [orderIndex, category, description, amount, updatedAt];
}
