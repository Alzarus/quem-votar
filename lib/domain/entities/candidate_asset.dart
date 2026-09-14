import 'package:equatable/equatable.dart';

/// Item de patrimonio declarado a Justica Eleitoral pelo candidato.
///
/// Reflete os bens informados na prestacao cadastral inicial do registro de
/// candidatura, discriminados por categoria, descricao e valor venal em Reais.
class CandidateAsset extends Equatable {
  final int orderIndex;
  final String category;
  final String description;
  final double amount;
  final String updatedAt;

  const CandidateAsset({
    required this.orderIndex,
    required this.category,
    required this.description,
    required this.amount,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [orderIndex, category, description, amount, updatedAt];
}
